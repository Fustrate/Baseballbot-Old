require 'baseballbot/version'
require 'baseballbot/template'
require 'baseballbot/template/base'
require 'baseballbot/template/gamechat'

module Baseballbot
  class << self
    def update_gamechats!
      current_gamechats.each(&:update!)
    end

    def post_gamechats!
    end

    def update_sidebars!
      subreddits.each(&:update_sidebar!)
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

    def config
      @config ||= YAML.load File.read '.baseballbot.yml'
    end

    def subreddits
      db
    end

    def current_gamechats
      db.exec_params('
        SELECT *
        FROM gamechats
        WHERE ended_at IS NULL
        AND starts_at < $1
        AND sport = $2', [Time.now, 'mlb']
      ) do |result|
        puts result.inspect
      end
    end
  end
end
