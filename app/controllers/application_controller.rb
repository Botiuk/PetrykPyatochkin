class ApplicationController < ActionController::Base
    include Pagy::Backend
    
    before_action :authenticate_user!

    def page_not_found
        render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
    end
end
