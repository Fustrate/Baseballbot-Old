module Baseballbot
  module CLI
    module Base
      protected

      def write_config(new_config)
        File.open(Baseballbot.config_file, 'w') do |f|
          f.write new_config.to_yaml
        end
      end

      def set_config_file
        Baseballbot.config_file = options[:config] if options[:config]
      end

      def log(string, color = nil)
        say(string, color) unless options[:quiet]
      end
    end
  end
end
