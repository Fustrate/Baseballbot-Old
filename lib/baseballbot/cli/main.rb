module Baseballbot
  module CLI
    class Main < Thor
      include Base

      class_option :quiet, type: :boolean, aliases: :Q
      class_option :config, type: :string, aliases: :C

      desc 'init', 'Initialize baseballbot with a database type'
      method_option :db,
                    required: true,
                    type: :string,
                    desc: 'The database to use, either mysql or pg'
      def init
        set_config_file

        case options[:db]
        when 'mysql'
          log "Initializing with mysql. Please edit the database connection details in #{Baseballbot.config_file}"
          FileUtils.cp File.expand_path('../examples/mysql.yml', __FILE__),
                       Baseballbot.config_file

        when 'pg', 'postgresql'
          log "Initializing with postgresql. Please edit the database connection details in #{Baseballbot.config_file}"
          FileUtils.cp File.expand_path('../examples/postgresql.yml', __FILE__),
                       Baseballbot.config_file

        else
          log 'Invalid database type'

        end
      end

      desc 'update', 'Update game chats or subreddits'
      option :teams, desc: 'Teams to update'
      def update(type)
        set_config_file

        teams = if options[:teams]
                  options[:teams].split(',')
                else

                end

        if type == 'sidebars'
          log 'Updating sidebars'

        elsif type == 'gamechats'
          log 'Updating gamechats'

        end
      end

      desc 'version', 'Display the installed version of Baseballbot'
      def version
        puts Baseballbot::VERSION
      end

      desc 'accounts SUBCOMMAND ...ARGS', 'Manage accounts for baseballbot to use'
      subcommand 'accounts', Baseballbot::CLI::Accounts

      desc 'subs SUBCOMMAND ...ARGS', 'Manage subreddits for baseballbot to update'
      subcommand 'subs', Baseballbot::CLI::Subs
    end
  end
end
