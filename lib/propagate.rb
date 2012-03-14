require 'propagate/configuration'
require 'propagate/client_helper'
require 'propagate/verify'

module Propagate
  PROPAGATE_API_SERVER_URL        = 'http://nakeit.propagate.com.br'
  PROPAGATE_API_SECURE_SERVER_URL = 'https://nakeit.propagate.com.br'
  PROPAGATE_VERIFY_URL            = 'http://nakeit.propagate.com.br'

  HANDLE_TIMEOUTS_GRACEFULLY      = true
  SKIP_VERIFY_ENV = ['test', 'cucumber']

  # Gives access to the current Configuration.
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Allows easy setting of multiple configuration options. See Configuration
  # for all available options.
  #--
  # The temp assignment is only used to get a nicer rdoc. Feel free to remove
  # this hack.
  #++
  def self.configure
    config = configuration
    yield(config)
  end

  def self.with_configuration(config)
    original_config = {}

    config.each do |key, value|
      original_config[key] = configuration.send(key)
      configuration.send("#{key}=", value)
    end

    result = yield if block_given?

    original_config.each { |key, value| configuration.send("#{key}=", value) }
    result
  end

  class PropagateError < StandardError
  end
end

if defined?(Rails)
  require 'propagate/rails'
end
