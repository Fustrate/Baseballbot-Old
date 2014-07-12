require 'baseballbot/version'
require 'baseballbot/template'
require 'baseballbot/template/base'
require 'baseballbot/template/gamechat'

require 'yaml'

module Baseballbot
  class << self
    attr_writer :config_file

    def update_gamechats!
      current_gamechats.each(&:update!)
    end

    def post_gamechats!
    end

    def update_sidebars!
      subreddits.each(&:update_sidebar!)
    end

    def config
      @config ||= begin
                    YAML.load File.read config_file
                  rescue Errno::ENOENT
                    raise %Q(Please run `baseballbot init` to generate a config file. Looked in "#{File.expand_path config_file}".)
                  end
    end

    def config_file
      @config_file || '.baseballbot.yml'
    end

    protected

    def db
      @db ||= case config[:db][:type]
              when 'pg'
                require 'pg'
                PG::Connect config[:db]
              when 'mysql'
                require 'mysql2'
                Mysql2::Client.new config[:db]
              else
                fail 'Please specify a database in the .baseballbot.yml file'
              end
    end

    def reddit
      @reddit ||= ''
    end

    def api
      @api ||= ''
    end

    def subreddits
      db
    end

    def current_gamechats
      db.exec_params('
        SELECT *
        FROM gamechats
        WHERE ended_at IS NULL
        AND starts_at < $1',
        [Time.now]
      ) do |result|
        puts result.inspect
      end
    end
  end
end
