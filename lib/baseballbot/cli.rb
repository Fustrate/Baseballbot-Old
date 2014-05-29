require 'thor'

module Baseballbot
  class CLI < Thor
    desc 'init', 'initialize baseballbot with a database type'
    method_option :db, required: true, type: :string, desc: 'The database to use, either mysql or pg'
    def init
      case options[:db]
      when 'mysql'
        puts 'Initializing with mysql'
        FileUtils.cp(File.expand_path('../examples/mysql.yml', __FILE__), '.baseballbot.yml')
      when 'pg', 'postgresql'
        puts 'Initializing with postgresql'
        FileUtils.cp(File.expand_path('../examples/postgresql.yml', __FILE__), '.baseballbot.yml')
      else
        puts 'Invalid database type'
      end
    end
  end
end

#
#
# # http://www.ruby-doc.org/stdlib/libdoc/optparse/rdoc/classes/OptionParser.html
# require 'optparse'
#
# module Baseballbot
#   class Parser
#     def self.parse(args)
#       new.parse(args)
#     end
#
#     def parse(args)
#       return {} if args.empty?
#
#       begin
#         parser(options).parse!(args)
#       rescue OptionParser::InvalidOption => e
#         abort "#{e.message}\n\nPlease use --help for a listing of valid options"
#       end
#
#       options
#     end
#
#     def parser(options)
#       OptionParser.new do |parser|
#         parser.banner = "Usage: baseballbot [options] [teams]\n\n"
#
#         parser.on('')
#
#         parser.on('-C', '--config', 'Set a custom configuration file.') do |file|
#           options[:config] = file
#         end
#
#         parser.on('--init', 'Initialize your project with RSpec.') do |cmd|
#           RSpec::Support.require_rspec_core "project_initializer"
#           ProjectInitializer.new.run
#           exit
#         end
#
#         parser.on('--update-sidebars',
#                   'Update sidebars.') do |teams|
#           Baseballbot.update_sidebars!
#         end
#
#         parser.on('--update-gamechats',
#                   'Update gamechats that have already been posted.') do |teams|
#           Baseballbot.update_gamechats!
#         end
#
#         parser.on('--post-gamechats',
#                   'Post gamechats that have not yet been posted.') do |teams|
#           Baseballbot.post_gamechats! options
#         end
#
#         parser.separator("\n  **** Utility ****\n\n")
#
#         parser.on('-v', '--version', 'Displays the version.') do
#           puts Baseballbot::Version
#           exit
#         end
#
#         parser.on_tail('-h', '--help', 'Displays the help page.') do
#           puts parser.to_s
#           exit
#         end
#       end
#     end
#   end
# end
