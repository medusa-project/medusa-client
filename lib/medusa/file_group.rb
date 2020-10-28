module Medusa

  ##
  # Represents a Medusa file group.
  #
  class FileGroup

    include Resource

    ##
    # @param uuid [String] Medusa database ID.
    # @return [Medusa::FileGroup]
    #
    def self.with_id(id)
      fg = FileGroup.new
      fg.instance_variable_set('@id', id)
      fg
    end

    ##
    # @param uuid [String] Medusa UUID.
    # @return [Medusa::FileGruop]
    #
    def self.with_uuid(uuid)
      fg = FileGroup.new
      fg.instance_variable_set('@uuid', uuid)
      fg
    end

    def initialize
      @loading      = false
      @loaded       = false
      @collection   = nil
      @directory    = nil
      @directory_id = nil
      @id           = nil
    end

    ##
    # @return [Medusa::Collection] Owning collection.
    #
    def collection
      load
      @collection ||= Collection.with_id(@collection_id)
    end

    ##
    # @return [Medusa::Directory] For instances with a {storage_level} of
    #                             `bit_level`, the root directory of the file
    #                             group. Otherwise, `nil`.
    #
    def directory
      load
      if @directory_id
        @directory ||= Directory.with_id(@directory_id)
      else
        nil
      end
    end

    ##
    # @return [String]
    #
    def external_file_location
      load
      @external_file_location
    end

    ##
    # @return [Integer] Medusa database ID.
    #
    def id
      load unless @id
      @id
    end

    ##
    # @return [String]
    #
    def storage_level
      load
      @storage_level
    end

    ##
    # @return [String]
    #
    def title
      load
      @title
    end

    ##
    # @return [String] Medusa UUID.
    #
    def uuid
      load unless @uuid
      @uuid
    end

    ##
    # Updates the instance with current properties from Medusa.
    #
    # It should not typically be necessary to use this method publicly.
    #
    def load
      return if @loading || @loaded
      @loading                = true
      struct                  = fetch_body
      @collection_id          = struct['collection_id']
      @directory_id           = struct['cfs_directory']['id'] if struct['cfs_directory']
      @external_file_location = struct['external_file_location']
      @id                     = struct['id']
      @storage_level          = struct['storage_level']
      @title                  = struct['title']
      @uuid                   = struct['uuid']
      @loaded                 = true
    end

    ##
    # @return [String] Absolute URI of the corresponding Medusa resource.
    #
    def url
      [::Medusa::Client.configuration[:medusa_base_url].chomp('/'),
       'file_groups',
       self.id].join('/')
    end

  end


end