module Baseballbot
  module CLI
    # Command line functionality for adding and removing subreddits and the
    # default template files for them.
    class Subs < Thor
      include Base

      desc 'add SUBREDDIT TEAM ACCOUNT', 'Add a new subreddit'
      option :sidebar, type: :boolean, default: true
      option :gamechats, type: :boolean, default: true
      def add(subreddit, team, account)
        set_config_file

        subreddit.downcase!
        account.downcase!

        config = Baseballbot.config

        config['subreddits'][subreddit] = {
          'account' => account,
          'sidebar' => options['sidebar'],
          'gamechats' => options['gamechats']
        }

        write_config config

        FileUtils.mkdir_p %W(subreddits/ templates/#{subreddit}/)

        template = ERB.new open('../../examples/team.erb').read, nil, '<>'

        write_file "subreddits/#{subreddit}.rb", template.result(binding)

        if options[:sidebar]
          copy_example_file 'sidebar.erb', "templates/#{subreddit}/sidebar.erb"
        end

        if options[:gamechats]
          copy_example_file 'gamechat.erb',
                            "templates/#{subreddit}/gamechat.erb"
          copy_example_file 'gamechat_partial.erb',
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
