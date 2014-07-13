module Baseballbot
  module CLI
    module Base
      protected

      def write_file(path, contents)
        File.open(path, 'w') do |f|
          f.write contents
        end
      end

      def write_config(new_config)
        write_file(Baseballbot.config_file, new_config.to_yaml)
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
