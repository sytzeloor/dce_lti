require 'oauth/request_proxy/rack_request'
require 'oauth/request_proxy/action_controller_request'

module DceLti
  class SessionsController < ApplicationController
    include SessionHelpers

    # skip_before_filter :verify_authenticity_token, :authenticate_via_lti
    skip_before_filter :verify_authenticity_token

    def create
      if valid_lti_request?(request)
        user = UserInitializer.find_from(tool_provider)
        session[:current_user_id] = user.id
        session.merge!(captured_attributes_from(tool_provider))
        redirect_to redirect_after_successful_auth
      else
        render :invalid
      end
    end
  end
end
