module Baseballbot
  module CLI
    class Subs < Thor
      include Base

      desc 'add SUBREDDIT ACCOUNT', 'Add a new subreddit'
      option :sidebar, type: :boolean, default: true
      option :gamechats, type: :boolean, default: true
      def add(subreddit, account)
        set_config_file

        config = Baseballbot.config

        config['subreddits'][subreddit] = {
          sidebar: options['sidebar'],
          gamechats: options['gamechats']
        }

        write_config config

        log "Added #{username} to baseballbot subreddits"
      end

      desc 'remove SUBREDDIT', 'Remove a subreddit'
      def remove(subreddit)
        set_config_file

        config = Baseballbot.config

        config['subreddits'].delete subreddit if config['subreddits']

        write_config config

        log "Removed #{username} from baseballbot subreddits"
      end
    end
  end
end
