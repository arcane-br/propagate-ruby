require "uri"
module Propagate
  module Verify
    # Your private API can be specified in the +options+ hash or preferably
    # using the Configuration.
    def verify_propagate(options = {})
      if !options.is_a? Hash
        options = {:model => options}
      end

      env = options[:env] || ENV['RAILS_ENV']
      return true if Propagate.configuration.skip_verify_env.include? env
      model = options[:model]
      attribute = options[:attribute] || :base
      private_key = options[:private_key] || Propagate.configuration.private_key
      raise PropagateError, "No private key specified." unless private_key

      begin
        propagate = nil
        if(Propagate.configuration.proxy)
          proxy_server = URI.parse(Propagate.configuration.proxy)
          http = Net::HTTP::Proxy(proxy_server.host, proxy_server.port, proxy_server.user, proxy_server.password)
        else
          http = Net::HTTP
        end

        Timeout::timeout(options[:timeout] || 3) do
	  uri = Propagate.configuration.verify_url + '/session/' + params[:propagate_sid] + '/answer/'
          propagate = http.post_form(URI.parse(uri), {
            "pk" => private_key,
            "remote_addr"   => request.remote_ip,
            "forwarded_for" => request.env['HTTP_X_FORWARDED_FOR'] || '',
            "user_agent"    => request.env['HTTP_USER_AGENT'],
            "sid"           => params[:propagate_sid],
            "answer"        => params[:propagate_challenge]
          })
        end
        answer, error = propagate.body.split.map { |s| s.chomp }
        unless answer == 'Ok'
          flash[:propagate_error] = if defined?(I18n)
            I18n.translate("propagate.errors.#{error}", {:default => error})
          else
            error
          end

          if model
            message = "Word verification response is incorrect, please try again."
            message = I18n.translate('propagate.errors.verification_failed', {:default => message}) if defined?(I18n)
            model.errors.add attribute, options[:message] || message
          end
          return false
        else
          flash.delete(:propagate_error)
          return true
        end
      rescue Timeout::Error
        if Propagate.configuration.handle_timeouts_gracefully
          flash[:propagate_error] = if defined?(I18n)
            I18n.translate('propagate.errors.propagate_unreachable', {:default => 'Propagate unreachable.'})
          else
            'Propagate unreachable.'
          end

          if model
            message = "Oops, we failed to validate your word verification response. Please try again."
            message = I18n.translate('propagate.errors.propagate_unreachable', :default => message) if defined?(I18n)
            model.errors.add attribute, options[:message] || message
          end
          return false
        else
          raise PropagateError, "Propagate unreachable."
        end
      rescue Exception => e
        raise PropagateError, e.message, e.backtrace
      end
    end # verify_propagate
  end # Verify
end # Propagate
