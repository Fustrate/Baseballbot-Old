require 'thor'
require 'baseballbot'

module Baseballbot
  class CLI < Thor
    class_option :quiet, type: :boolean, aliases: :Q

    desc 'init', 'initialize baseballbot with a database type'
    method_option :db,
                  required: true,
                  type: :string,
                  desc: 'The database to use, either mysql or pg'
    def init
      case options[:db]
      when 'mysql'
        log 'Initializing with mysql'
        FileUtils.cp File.expand_path('../examples/mysql.yml', __FILE__),
                     '.baseballbot.yml'

      when 'pg', 'postgresql'
        log 'Initializing with postgresql'
        FileUtils.cp File.expand_path('../examples/postgresql.yml', __FILE__),
                     '.baseballbot.yml'

      else
        log 'Invalid database type'

      end
    end

    desc 'update', 'update game chats or subreddits'
    option :teams, desc: 'Teams to update'
    def update(type)
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

    desc 'version', 'display the installed version of Baseballbot'
    def version
      puts Baseballbot::VERSION
    end

    protected

    def log(string)
      puts string unless options[:quiet]
    end
  end
end
