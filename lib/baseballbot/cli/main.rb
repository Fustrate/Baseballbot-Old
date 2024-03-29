module Baseballbot
  module CLI
    class Main < Thor
      include Base

      class_option :quiet, type: :boolean, aliases: :Q
      class_option :config, type: :string, aliases: :C

      desc 'init {mysql|pg}', 'Initialize baseballbot with a database type'
      def init(db)
        set_config_file

        config = {
          'db' => {
            'adapter' => db,
            'username' => '',
            'password' => '',
            'database' => ''
          },
          'useragent' => '',
          'accounts' => {},
          'subreddits' => {}
        }

        if %w(mysql pg).include? db
          log "Initializing with #{db}. Please edit the database connection details in #{Baseballbot.config_file}", :green

          write_config config

        else
          log 'Invalid database type.', :red

        end
      end

      desc 'update {gamechats|sidebars}', 'Update game chats or subreddits'
      option :teams, desc: 'Teams to update'
      def update(type)
        set_config_file

        teams = if options[:teams]
                  options[:teams].split(',')
                else

                end

        if type == 'sidebars'
          log 'Updating sidebars', :green

        elsif type == 'gamechats'
          log 'Updating gamechats', :green

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
