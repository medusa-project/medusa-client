require 'set'

module Medusa

  ##
  # Represents a Medusa repository node.
  #
  class Repository

    include Resource

    ##
    # @param id [Integer] Medusa database ID.
    # @return [Medusa::Repository]
    #
    def self.with_id(id)
      repo = Repository.new
      repo.instance_variable_set('@id', id)
      repo
    end

    ##
    # @param uuid [String] Medusa UUID.
    # @return [Medusa::Repository]
    #
    def self.with_uuid(uuid)
      repo = Repository.new
      repo.instance_variable_set('@uuid', uuid)
      repo
    end

    def initialize
      @loading     = false
      @loaded      = false
      @collections = Set.new
      @id          = nil
    end

    ##
    # @return [Enumerable<Medusa::Collection>]
    #
    def collections
      load
      @collections
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
    def email
      load
      @email
    end

    ##
    # @return [String]
    #
    def home_url
      load
      @home_url
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
    def ldap_admin_domain
      load
      @ldap_admin_domain
    end

    ##
    # @return [String]
    #
    def ldap_admin_group
      load
      @ldap_admin_group
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
      @loading           = true
      struct             = fetch_body
      @contact_email     = struct['contact_email']
      @email             = struct['email']
      @home_url          = struct['url']
      @id                = struct['id']
      @ldap_admin_domain = struct['ldap_admin_domain']
      @ldap_admin_group  = struct['ldap_admin_group']
      @title             = struct['title']
      @uuid              = struct['uuid']
      struct['collections'].each do |col_struct|
        @collections << Collection.with_id(col_struct['id'])
      end
      @loaded = true
    end

    ##
    # @return [String] Absolute URI of the corresponding Medusa resource.
    #
    def url
      [Client.configuration[:medusa_base_url].chomp('/'),
       'repositories',
       self.id].join('/')
    end

  end


end