require 'httpclient'
require 'singleton'

module Medusa

  ##
  # High-level client for the Medusa Collection Registry.
  #
  #noinspection RubyClassVariableUsageInspection
  class Client

    include ::Singleton

    @@configuration = {
        medusa_base_url: ENV['MEDUSA_BASE_URL'],
        medusa_user:     ENV['MEDUSA_USER'],
        medusa_secret:   ENV['MEDUSA_SECRET']
    }

    def self.configuration
      @@configuration
    end

    def self.configuration=(config)
      @@configuration = config
      instance.instance_variable_set('@http_client', nil)
    end

    ##
    # @param uuid [String]
    # @return [Class]
    #
    def class_of_uuid(uuid)
      url      = url_for_uuid(uuid) + '.json'
      response = get(url, follow_redirect: false)
      location = response.header['location'].first
      if location&.include?('/repositories/')
        ::Medusa::Repository
      elsif location&.include?('/collections/')
        ::Medusa::Collection
      elsif location&.include?('file_groups/')
        ::Medusa::FileGroup
      elsif location&.include?('/cfs_directories/')
        ::Medusa::Directory
      elsif location&.include?('/cfs_files/')
        ::Medusa::File
      end
    end

    def get(url, *args)
      args = merge_args(args)
      http_client.get(url, args)
    end

    def get_uuid(url, *args)
      get(url_for_uuid(url), args)
    end

    def head(url, *args)
      args = merge_args(args)
      http_client.head(url, args)
    end

    ##
    # @param uuid [String]
    # @return [String, nil] URI of the corresponding Medusa resource.
    #
    def url_for_uuid(uuid)
      [self.class.configuration[:medusa_base_url].chomp('/'), 'uuids', uuid].join('/')
    end

    private

    ##
    # @return [HTTPClient] With auth credentials already set.
    #
    def http_client
      config = self.class.configuration
      url    = config[:medusa_base_url]
      user   = config[:medusa_user]
      secret = config[:medusa_secret]
      @http_client ||= ::HTTPClient.new do
        # use the OS cert store
        self.ssl_config.cert_store.set_default_paths
        #self.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
        self.force_basic_auth = true
        self.receive_timeout = 10000
        uri    = URI.parse(url)
        domain = "#{uri.scheme}://#{uri.host}"
        user   = user
        secret = secret
        self.set_auth(domain, user, secret)
      end
    end

    def merge_args(args)
      extra_args = { follow_redirect: true }
      if args[0].kind_of?(Hash)
        args[0] = extra_args.merge(args[0])
      else
        return extra_args
      end
      args
    end

  end

end
