$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "medusa"

Medusa::Client.configuration = {
    medusa_base_url: ENV['MEDUSA_BASE_URL'],
    medusa_user:     ENV['MEDUSA_USER'],
    medusa_secret:   ENV['MEDUSA_SECRET']
}

require "minitest/autorun"
