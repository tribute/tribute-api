module Tribute
  module Helpers
    module Urls
      def url(relative_url)
        URI.join(request.base_url, relative_url).to_s if relative_url
      end
    end
  end
end
