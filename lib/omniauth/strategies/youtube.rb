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
          nickname:    value_for_key_path('yt$username', '$t'),
          first_name:  value_for_key_path('yt$firstName', '$t'),
          last_name:   value_for_key_path('yt$lastName', '$t'),
          image:       value_for_key_path('media$thumbnail', 'url'),
          description: value_for_key_path('yt$description', '$t'),
          location:    value_for_key_path('yt$location', '$t')
        })
      end
      
      extra do
        prune!({
          raw_info: raw_info
        })
      end
      
      def raw_info
        @raw_info ||= access_token.get('/feeds/api/users/default?alt=json&v=2.1').parsed['entry']
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

      # not all keys are returned by youtube API
      def value_for_key_path(*args)
        value = raw_info
        args.each do |a|
          value = value[a]
          break if value.nil?
        end
        value
      end
    end
  end
end

OmniAuth.config.add_camelization 'youtube', 'YouTube'
