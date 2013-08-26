require 'generators/user_notification'
require 'rails/generators/active_record'

module UserNotification
  module Generators
    # Migration generator that creates migration file from template
    class MigrationGenerator < ActiveRecord::Generators::Base
      extend Base

      argument :name, :type => :string, :default => 'create_notifications'
      # Create migration in project's folder
      def generate_files
        migration_template 'create_notifications.rb', "db/migrate/#{name}"
        migration_template 'create_notifyings.rb', "db/migrate/#{name}"
      end
    end
  end
end
