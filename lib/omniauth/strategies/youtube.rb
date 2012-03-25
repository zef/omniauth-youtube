require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class YouTube < OmniAuth::Strategies::OAuth2      
      option :name, "youtube"
      option :authorize_options, [:scope, :approval_prompt, :access_type]
      
      option :client_options, {
        site: 'https://gdata.youtube.com',
        authorize_url: 'https://accounts.google.com/o/oauth2/auth',
        token_url: 'https://accounts.google.com/o/oauth2/token'
      }
      
      uid { raw_info['id']['$t'] }
      
      info do
        prune!({
          nickname: raw_info['author'].first['name']['$t'],
          first_name: raw_info['yt$firstName']['$t'],
          last_name: raw_info['yt$lastName']['$t'],
          image: raw_info['media$thumbnail']['url'],
          description: raw_info['yt$description']['$t'],
          location: raw_info['yt$location']['$t']
        })
      end
      
      extra do
        prune!({
          raw_info: raw_info
        })
      end
      
      def raw_info
        @raw_info ||= access_token.get('/feeds/api/users/default?alt=json').parsed['entry']
      end

      def authorize_params
        super.tap do |params|
          params[:scope] ||= 'https://gdata.youtube.com'
          params[:access_type] ||= 'offline'
          params[:approval_prompt] ||= 'force'
        end
      end
      
      private
      
      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end
    end
  end
end

OmniAuth.config.add_camelization 'youtube', 'YouTube'
