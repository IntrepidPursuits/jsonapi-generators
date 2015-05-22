module Jsonapi
  module Generators
    class SetupGenerator < Rails::Generators::Base
      desc 'Setup base gems and configuration'
      source_root File.expand_path('../../templates', __FILE__)

      def add_gems
        insert_into_file 'Gemfile', global_gems, before: first_gem
        insert_into_file 'Gemfile', test_gems, after: "group :test do\n"
      end

      def configure_json_spec
        insert_into_file 'spec/rails_helper.rb',
                         json_spec_helper,
                         after: "RSpec.configure do |config|\n"
      end

      def configure_json_schema
        copy_file 'spec/support/matchers/api_schema_matcher.rb',
                  'spec/support/matchers/api_schema_matcher.rb'
      end

      def configure_puma
        copy_file 'Procfile', 'Procfile'
        copy_file 'config/puma.rb', 'config/puma.rb'
        remove_file 'config/unicorn.rb'
      end

      def configure_versionist
        insert_into_file 'config/routes.rb',
                         versionist_route_helper,
                         after: "Rails.application.routes.draw do\n"
      end

      def configure_pg_uuid_extension
        generate 'migration', 'enable_uuid_extension'
        uuid_migration = Dir.glob('db/migrate/*').select { |f| f.match('enable_uuid_extension') }.first
        insert_into_file uuid_migration,
                         "enable_extension 'uuid-ossp'\n".indent(4),
                         after: "def change\n"
      end

      private

      def first_gem
        File.read('Gemfile').match(/gem .+/)[0]
      end

      def global_gems
        <<-GEMS
gem 'active_model_serializers', '0.8.3'
gem 'foreman'
gem 'puma'
gem 'versionist'
GEMS
      end

      def test_gems
        <<-GEMS
  gem 'json-schema'
  gem 'json_spec'
GEMS
      end

      def json_spec_helper
        "config.include JsonSpec::Helpers\n".indent(2)
      end

      def versionist_route_helper
        <<-VERSIONIST
  api_version(module: 'V1',
              header: {
                name: 'Accept',
                value: 'application/vnd.#{app_name}.com+json; version=1' },
              defaults: { format: :json }) do
  end
VERSIONIST
      end

      def app_name
        Dir.pwd.split('/').last
      end
    end
  end
end
