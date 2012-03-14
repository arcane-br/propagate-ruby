module Propagate
  module ClientHelper
    # Your public API can be specified in the +options+ hash or preferably
    # using the Configuration.
    def propagate_tags(options = {})
      # Default options
      key   = options[:public_key] ||= Propagate.configuration.public_key
      raise PropagateError, "No public key specified." unless key
      error = options[:error] ||= (defined? flash ? flash[:propagate_error] : "")
      uri   = Propagate.configuration.api_server_url(options[:ssl])
      html  = ""


      html << %{<script type="text/javascript" src="#{uri}/site/#{key}/session/?}
      html << %{#{error ? "&amp;error=#{CGI::escape(error)}" : ""}"></script>\n}

      return (html.respond_to?(:html_safe) && html.html_safe) || html
    end # propagate_tags
  end # ClientHelper
end # Propagate
