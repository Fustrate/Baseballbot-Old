module Baseballbot
  module CLI
    class Subs < Thor
      include Base

      desc 'add SUBREDDIT TEAM ACCOUNT', 'Add a new subreddit'
      option :sidebar, type: :boolean, default: true
      option :gamechats, type: :boolean, default: true
      def add(subreddit, team, account)
        set_config_file

        config = Baseballbot.config

        config['subreddits'][subreddit] = {
          'account' => account,
          'sidebar' => options['sidebar'],
          'gamechats' => options['gamechats'],
        }

        write_config config

        FileUtils.cp File.expand_path('../../examples/team.rb', __FILE__),
                     "subreddits/#{subreddit}.rb"

        FileUtils.mkdir_p "templates/#{subreddit}/"

        if options[:sidebar]
          FileUtils.cp File.expand_path('../../examples/sidebar.erb', __FILE__),
                       "templates/#{subreddit}/sidebar.erb"
        end

        if options[:gamechats]
          FileUtils.cp File.expand_path('../../examples/gamechat.erb', __FILE__),
                       "templates/#{subreddit}/gamechat.erb"

          FileUtils.cp File.expand_path('../../examples/gamechat_partial.erb', __FILE__),
                       "templates/#{subreddit}/gamechat_partial.erb"
        end

        log "Added #{subreddit} to baseballbot subreddits"
      end

      desc 'remove SUBREDDIT', 'Remove a subreddit'
      def remove(subreddit)
        set_config_file

        config = Baseballbot.config

        config['subreddits'].delete subreddit if config['subreddits']

        write_config config

        log "Removed #{subreddit} from baseballbot subreddits"
      end
    end
  end
end
