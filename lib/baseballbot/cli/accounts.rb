module Baseballbot
  module CLI
    # Command line functionality for adding and removing reddit accounts that
    # can be used to update sidebars and gamechats.
    class Accounts < Thor
      include Base

      desc 'add USERNAME PASSWORD', 'Add a new reddit account'
      def add(username, password)
        set_config_file

        config = Baseballbot.config

        config['accounts'][username] = password

        write_config config

        log "Added #{username} to baseballbot accounts"
      end

      desc 'remove USERNAME', 'Remove a reddit account'
      def remove(username)
        set_config_file

        config = Baseballbot.config

        config['accounts'].delete username if config['accounts']

        write_config config

        log "Removed #{username} from baseballbot accounts"
      end
    end
  end
end
