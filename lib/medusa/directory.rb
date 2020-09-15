module Medusa

  ##
  # Represents a Medusa directory.
  #
  class Directory < Node

    include Resource

    attr_accessor :json

    ##
    # Initializes a new instance from a JSON fragment.
    #
    # @param json [Hash]
    # @return [Medusa::Directory]
    #
    def self.from_json(json)
      dir = Medusa::Directory.new
      dir.json = json
      dir.load
      dir
    end

    ##
    # @param id [Integer]
    # @return [Medusa::Directory]
    #
    def self.with_id(id)
      dir = Directory.new
      dir.instance_variable_set('@id', id)
      dir
    end

    ##
    # @param uuid [String]
    # @return [Medusa::Directory]
    #
    def self.with_uuid(uuid)
      dir = Directory.new
      dir.instance_variable_set('@uuid', uuid)
      dir
    end

    def initialize
      super
      # These relate to the /cfs_directories/:id.json representation.
      @files                 = Set.new
      @directories           = Set.new
      @loaded                = false
      # These relate to the /cfs_directories/:id/show_tree.json representation.
      @directory_tree        = nil
      @directory_tree_loaded = false
    end

    ##
    # @return [Enumerable<Medusa::Directory>]
    #
    def directories
      load
      @directories
    end

    ##
    # @return [String] URI of the corresponding Medusa directory tree resource.
    # @see url
    #
    def directory_tree_url
      self.url + '/show_tree.json'
    end

    ##
    # @return [Enumerable<Medusa::File>]
    #
    def files
      load
      @files
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
      @relative_key = struct['relative_pathname']
      @uuid         = struct['uuid']
      struct['subdirectories'].each do |subdir|
        @directories << Directory.with_id(subdir['id'])
      end
      struct['files'].each do |file|
        @files << File.from_json(file)
      end
      @loaded = true
    end

    ##
    # @return [String] Absolute URI of the corresponding Medusa resource.
    # @see directory_tree_url
    #
    def url
      [::Medusa::Client.configuration[:medusa_base_url].chomp('/'),
       'cfs_directories',
       self.id].join('/')
    end

    ##
    # Pass a block to invoke it on every {File} and {Directory} node at any
    # level within this instance, including the instance itself.
    #
    def walk_tree(&block)
      load_directory_tree
      yield self
      walk(@directory_tree, &block)
    end


    private

    def load_directory_tree
      return if @directory_tree_loaded
      load unless self.id
      @directory_tree = fetch_body(self.directory_tree_url)
      @directory_tree_loaded = true
    end

    def walk(dir_struct, &block)
      dir_struct['subdirectories'].each do |subdir|
        yield Directory.from_json(subdir)
        walk(subdir, &block)
      end
      dir_struct['files'].each do |file|
        yield File.from_json(file)
      end
    end

  end

end
