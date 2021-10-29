module Medusa

  ##
  # Represents a Medusa collection.
  #
  class Collection

    include Resource

    ##
    # Returns a new instance with the given ID. Existence is not checked, so
    # an instance is returned regardless of whether the ID is valid.
    #
    # @param id [Integer] Medusa database ID.
    # @return [Medusa::Collection]
    #
    def self.with_id(id)
      col = Collection.new
      col.instance_variable_set('@id', id)
      col
    end

    ##
    # Returns a new instance with the given UUID. Existence is not checked, so
    # an instance is returned regardless of whether the UUID is valid.
    #
    # @param uuid [String] Medusa UUID.
    # @return [Medusa::Collection]
    #
    def self.with_uuid(uuid)
      col = Collection.new
      col.instance_variable_set('@uuid', uuid)
      col
    end

    def initialize
      @loading     = false
      @loaded      = false
      @file_groups = Set.new
      @id          = nil
      @uuid        = nil
    end

    def ==(obj)
      if obj.kind_of?(::Medusa::Collection)
        return obj.id == self.id && obj.uuid == self.uuid
      end
      false
    end

    ##
    # @return [String]
    #
    def access_url
      load
      @access_url
    end

    ##
    # @return [String]
    #
    def contact_email
      load
      @contact_email
    end

    ##
    # @return [String]
    #
    def description
      load
      @description
    end

    ##
    # @return [String]
    #
    def description_html
      load
      @description_html
    end

    ##
    # @return [String]
    #
    def external_id
      load
      @external_id
    end

    ##
    # @return [Enumerable<Medusa::FileGroup>]
    #
    def file_groups
      load
      @file_groups
    end

    ##
    # @return [String]
    #
    def physical_collection_url
      load
      @physical_collection_url
    end

    ##
    # @return [String]
    #
    def private_description
      load
      @private_description
    end

    ##
    # @return [Boolean]
    #
    def published?
      load
      @published
    end

    ##
    # @return [Medusa::Repository]
    #
    def repository
      load
      @repository ||= Repository.with_uuid(@repository_uuid)
    end

    ##
    # @return [String]
    #
    def representative_image
      load
      @representative_image
    end

    ##
    # @return [String] Digital Library item UUID.
    #
    def representative_item
      load
      @representative_item
    end

    ##
    # @return [String]
    #
    def title
      load
      @title
    end

    ##
    # Updates the instance with current properties from Medusa.
    #
    # It should not typically be necessary to use this method publicly.
    #
    def load
      return if @loading || @loaded
      @loading                 = true
      struct                   = fetch_body
      @access_url              = struct['access_url']
      @contact_email           = struct['contact_email']
      @description             = struct['description']
      @description_html        = struct['description_html']
      @external_id             = struct['external_id']
      @id                      = struct['id']
      @physical_collection_url = struct['physical_collection_url']
      @private_description     = struct['private_description']
      @published               = struct['publish']
      @representative_image    = struct['representative_image']
      @representative_item     = struct['representative_item']
      @repository_uuid         = struct['repository_uuid']
      @title                   = struct['title']
      @uuid                    = struct['uuid']
      struct['file_groups'].each do |group|
        @file_groups << FileGroup.with_id(group['id'])
      end
      @loaded = true
    ensure
      @loading = false
    end

    ##
    # @return [String] Absolute URI of the corresponding Medusa resource.
    #
    def url
      [::Medusa::Client.configuration[:medusa_base_url].chomp('/'),
       'collections',
       self.id].join('/')
    end

  end


end