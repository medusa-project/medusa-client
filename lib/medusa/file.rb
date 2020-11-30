module Medusa

  ##
  # Represents a Medusa file.
  #
  class File < Node

    include Resource

    attr_accessor :json

    ##
    # Initializes a new instance from a JSON fragment.
    #
    # @param json [Hash]
    # @return [Medusa::File]
    #
    def self.from_json(json)
      file = Medusa::File.new
      file.json = json
      file.load
      file
    end

    ##
    # Returns a new instance with the given ID. Existence is not checked, so
    # an instance is returned regardless of whether the ID is valid.
    #
    # @param id [Integer]
    # @return [Medusa::File]
    #
    def self.with_id(id)
      file = Medusa::File.new
      file.instance_variable_set('@id', id)
      file
    end

    ##
    # Returns a new instance with the given UUID. Existence is not checked, so
    # an instance is returned regardless of whether the UUID is valid.
    #
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
      @loading = @loaded = false
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
      return if @loading || @loaded
      @loading      = true
      struct        = json ? json : fetch_body
      @id           = struct['id']
      @md5_sum      = struct['md5_sum']
      @media_type   = struct['content_type']
      @mtime        = Time.parse(struct['mtime']) if struct['mtime']
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