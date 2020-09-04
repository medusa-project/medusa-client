module Medusa

  ##
  # Represents a Medusa file.
  #
  class File < Node

    include Resource

    attr_accessor :json

    ##
    # @param id [Integer]
    # @return [Medusa::File]
    #
    def self.with_id(id)
      file = Medusa::File.new
      file.instance_variable_set('@id', id)
      file
    end

    ##
    # For performance reasons, a {Medusa::Directory} representation includes
    # full {Medusa::File} representations in its `files` array. This method
    # initializes a new instance based on one of those so that no additional
    # HTTP requests are needed.
    #
    # @param json [Hash]
    # @return [Medusa::File]
    #
    def self.with_json(json)
      file = Medusa::File.new
      file.json = json
      file.load
      file
    end

    ##
    # @param uuid [String]
    # @return [Medusa::File]
    #
    def self.with_uuid(uuid)
      file = Medusa::File.new
      file.instance_variable_set('@uuid', uuid)
      file
    end

    def initialize
      super
      @loaded = false
    end

    ##
    # @return [Medusa::Directory]
    #
    def directory
      load
      @directory ||= ::Medusa::Directory.with_id(@directory_id)
    end

    ##
    # @return [String]
    #
    def md5_sum
      load
      @md5_sum
    end

    ##
    # @return [String]
    #
    def media_type
      load
      @media_type
    end

    ##
    # @return [Time]
    #
    def mtime
      load
      @mtime
    end

    ##
    # @return [Integer]
    #
    def size
      load
      @size
    end

    ##
    # Updates the instance with current properties from Medusa.
    #
    # It should not typically be necessary to use this method publicly.
    #
    def load
      return if @loaded
      struct        = json ? json : fetch_body
      @id           = struct['id']
      @md5_sum      = struct['md5_sum']
      @media_type   = struct['content_type']
      @mtime        = Time.parse(struct['mtime'])
      @relative_key = struct['relative_pathname']
      @size         = struct['size']
      @uuid         = struct['uuid']
      # this will only be present in the /cfs_files/:id representation, not the
      # one nested in /cfs_directories
      if struct['directory'] and struct['directory']['uuid']
        @directory_id = struct['directory']['id']
      end
      @loaded = true
    end

    ##
    # @return [String] Absolute URI of the corresponding Medusa resource.
    #
    def url
      [::Medusa::Client.configuration[:medusa_base_url].chomp('/'),
       'cfs_files',
       self.id].join('/')
    end

  end

end