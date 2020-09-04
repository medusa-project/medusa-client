module Medusa

  ##
  # Remote Medusa resource, identifiable by {id} or {uuid}.
  #
  module Resource

    include Uuidable

    protected

    ##
    # @return [Hash] Deserialized JSON response body.
    # @raises [RuntimeError] if neither {id} nor {uuid} attributes are set.
    # @raises [NotFoundError] for a 404 response.
    # @raises [IOError] for any other 400- or 500- level response.
    #
    def fetch_body
      raise 'fetch_body() called without ID or UUID set' unless self.id || self.uuid

      client   = Client.instance
      url      = (self.id ? self.url : self.uuid_url) + '.json'
      response = client.get(url)

      if response.status < 300
        JSON.parse(response.body)
      elsif response.status == 404
        raise NotFoundError, "#{self.class.to_s.split('::').last} ID #{self.id} not found in Medusa: #{url}"
      else
        raise IOError, "Received HTTP #{response.status} for GET #{url}"
      end
    end

  end

end