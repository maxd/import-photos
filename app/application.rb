require 'optparse'
require 'import_manager'

class Application

  def initialize
    @options = {}

    parse_args
  end

  def parse_args
    opts = OptionParser.new do |opts|
      opts.banner = 'Usage: import-photos.rb [options]'

      opts.separator ''
      opts.separator 'Options:'

      opts.on('-i', '--input-dir DIRECTORY', 'Input directory with photos') do |v|
        @options[:input_dir] = v
      end

      opts.on('-o', '--output-dir DIRECTORY', 'Output directory where will imported photos') do |v|
        @options[:output_dir] = v
      end

      opts.on('-u', '--user [USER]', 'Owner of output files') do |v|
        @options[:user] = v
      end

      opts.on('-g', '--group [GROUP]', 'Owner of output files') do |v|
        @options[:group] = v
      end
    end

    begin
      opts.parse!

      mandatory = [:input_dir, :output_dir]
      missing = mandatory.select{ |param| @options[param].nil? }
      unless missing.empty?
        puts "Missing options: #{missing.map {|v| "--#{v.to_s.gsub(/_/, '-')}" }.join(', ')}"
        puts opts
        exit
      end
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument
      puts $!.to_s
      puts opts
      exit
    end
  end

  def run
    import_manager = ImportManager.new(@options)
    import_manager.process
  end

end
