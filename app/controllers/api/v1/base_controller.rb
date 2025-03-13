module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_devise_api_token!
      before_action :set_current_user

      protected

      def set_current_user
        devise_api_token = current_devise_api_token
        @current_user = devise_api_token.resource_owner
      end

      def dynamic_action
        if card_params.keys == [ "status" ]
          :move
        else
          :update
        end
      end
    end
  end
end
