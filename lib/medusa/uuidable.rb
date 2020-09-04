module Medusa

  module Uuidable

    ##
    # @return [String] Absolute URI of the Medusa resource, or nil if the
    #                  instance does not have a UUID.
    #
    def uuid_url
      if self.uuid
        [::Medusa::Client.configuration[:medusa_base_url].chomp('/'),
         'uuids',
         self.uuid.to_s.strip].join('/')
      end
    end

  end

end