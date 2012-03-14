require 'propagate'

Merb::GlobalHelpers.send(:include, Propagate::ClientHelper)
Merb::Controller.send(:include, Propagate::Verify)
