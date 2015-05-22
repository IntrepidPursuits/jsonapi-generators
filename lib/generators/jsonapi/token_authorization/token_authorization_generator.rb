module Jsonapi
  module Generators
    class TokenAuthorizationGenerator < Rails::Generators::Base
      desc 'Create a TokenAuthorization strategy for Warden'
      source_root File.expand_path('../../templates', __FILE__)

      def copy_token_authorization
        copy_file 'app/strategies/token_authentication_strategy.rb'
      end

      def create_user_for_authentication_method
        inject_into_class 'app/models/user.rb', User do
          user_for_authentication
        end
      end

      def add_warden_translation_strings
        insert_into_file 'config/locales/en.yml', warden_translation_strings, after: /\Z/
      end

      private

      def user_for_authentication
        <<-RUBY
  def self.for_authentication(token)
    where(authentication_token: token).
      where('authentication_token_expires_at > ?', Time.current).
      first
  end
RUBY
      end

      def warden_translation_strings
        <<-YAML
  warden:
    messages:
      failure: A user was not found from this token
YAML
      end
    end
  end
end
