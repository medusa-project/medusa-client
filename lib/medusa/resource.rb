module Medusa

  ##
  # Remote Medusa resource, identifiable by {id} or {uuid}.
  #
  module Resource

    include Uuidable

    ##
    # @return [Boolean] Whether the instance exists in Medusa.
    #
    def exists?
      load
      true
    rescue Medusa::NotFoundError
      false
    end

    ##
    # @return [Integer] Medusa database ID.
    #
    def id
      load if @uuid && !@id
      @id
    end

    ##
    # @return [String] Medusa UUID.
    #
    def uuid
      load if @id && !@uuid
      @uuid
    end

    protected

    ##
    # @param url_path [String] Overrides the URL path.
    # @return [Hash] Deserialized JSON response body.
    # @raises [RuntimeError] if neither {id} nor {uuid} attributes are set.
    # @raises [NotFoundError] for a 404 response.
    # @raises [IOError] for any other 400- or 500- level response.
    #
    def fetch_body(url_path = nil)
      raise 'fetch_body() called without ID or UUID set' unless self.id || self.uuid

      client   = Client.instance
      url      = url_path || ((@id ? self.url : self.uuid_url) + '.json')
      response = client.get(url)

      if response.status < 300
        JSON.parse(response.body)
      elsif response.status == 404
        raise NotFoundError, "#{self.class.to_s.split('::').last} ID #{@id} not found in Medusa: #{url}"
      else
        raise IOError, "Received HTTP #{response.status} for GET #{url}"
      end
    end

  end

end