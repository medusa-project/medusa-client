module Medusa

  ##
  # Represents a Medusa directory.
  #
  class Directory < Node

    include Resource

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
      @files       = Set.new
      @directories = Set.new
      @loaded      = false
    end

    ##
    # @return [Enumerable<Medusa::Directory>]
    #
    def directories
      load
      @directories
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
      struct        = fetch_body
      @id           = struct['id']
      @relative_key = struct['relative_pathname']
      @uuid         = struct['uuid']
      struct['subdirectories'].each do |subdir|
        @directories << Directory.with_id(subdir['id'])
      end
      struct['files'].each do |file|
        @files << File.with_json(file)
      end
      @loaded = true
    end

    ##
    # @return [String] Absolute URI of the corresponding Medusa resource.
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
      yield self
      walk(self, &block)
    end


    private

    def walk(dir, &block)
      dir.directories.each do |subdir|
        yield subdir
        walk(subdir, &block)
      end
      dir.files.each do |file|
        yield file
      end
    end

  end

end
