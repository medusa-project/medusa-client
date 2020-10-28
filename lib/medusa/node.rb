module Medusa

  ##
  # Abstract base class for {File} and {Directory}.
  #
  class Node

    def initialize
      @id = @uuid = nil
    end

    ##
    # @return [Integer] Medusa database ID.
    #
    def id
      load unless @id
      @id
    end

    ##
    # @return [String] Last path component of {relative_key}.
    #
    def name
      ::File.basename(self.relative_key)
    end

    ##
    # @return [String]
    #
    def relative_key
      load
      @relative_key
    end

    ##
    # @return [String] Medusa UUID.
    #
    def uuid
      load unless @uuid
      @uuid
    end

    def load
      raise 'Subclasses must implement load()'
    end

  end

end