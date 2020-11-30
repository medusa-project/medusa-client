module Medusa

  ##
  # Abstract base class for {File} and {Directory}.
  #
  class Node

    def initialize
      @id = @uuid = nil
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

    def load
      raise 'Subclasses must implement load()'
    end

  end

end