require 'net/http'
require 'propagate'
module Rails
  module Propagate
    class Railtie < Rails::Railtie
      initializer "setup config" do
        begin
          ActionView::Base.send(:include, ::Propagate::ClientHelper)
          ActionController::Base.send(:include, ::Propagate::Verify)
        end
      end
    end
  end
end

