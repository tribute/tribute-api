module Tribute
  class API < Grape::API
    
    version 'v1', using: :header, vendor: 'tribute', strict: false
    format :json
        
    helpers Tribute::Helpers::Urls
    
    desc "Hypermedia API root."
    get do
      {
        status_url: url('status')
      }
    end
    
    mount Tribute::Status
    mount Tribute::Auth

  end
end

