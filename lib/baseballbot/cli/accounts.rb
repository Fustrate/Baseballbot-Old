module Baseballbot
  class CLI < Thor
    class Accounts < Thor
      include Base

      desc 'add USERNAME PASSWORD', 'Add a new reddit account'
      def add(username, password)
        set_config_file

        config = Baseballbot.config

        config['accounts'] ||= {}
        config['accounts'][username] = password

        write_config config

        log "Added #{username} to baseballbot accounts"
      end
    end
  end
end
