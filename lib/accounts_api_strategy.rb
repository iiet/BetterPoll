require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class AccountsApi < OmniAuth::Strategies::OAuth2
      # change the class name and the :name option to match your application name
      option :name, :accounts_api

      option :client_options, {
                                :site => ENV['ACCOUNTS_API_BASE_URL'],
                                :authorize_url => '/oauth/authorize'
                            }

      uid { raw_info['user_id'] }

      info do
        {
          login: raw_info['login'],
          first_name: raw_info['first_name'],
          last_name: raw_info['last_name'],
          email: raw_info['email']
        }
      end

      option :authorize_params, { scope: ['public','extended'].join(" ") }

      def raw_info
        @raw_info ||= access_token.get('/oauth/v1/extended').parsed
        pp @raw_info
      end
    end
  end
end