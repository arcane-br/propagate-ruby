require 'net/http'
require 'propagate'

ActionView::Base.send(:include, Propagate::ClientHelper)
ActionController::Base.send(:include, Propagate::Verify)
