require 'find'
require 'fileutils'
require 'duplicate_manager'

class ImportManager

  def initialize(options)
    @options = options
    @duplicate_manager = DuplicateManager.new(@options[:output_dir])
  end

  def process
    result = copy_files

    puts "Imported #{result[:total_files] - result[:duplicate_files]} from #{result[:total_files]} files."
    puts "---"
    puts "Renamed:    #{result[:renamed_files]}"
    puts "Duplicates: #{result[:duplicate_files]} (skipped)"
  end

private

  def enumerate_files(path)
    Find.find(path) do |input_file|
      Find.prune if FileTest.directory?(input_file) and is_dot_file?(input_file)

      yield(input_file) if FileTest.file?(input_file) and !is_dot_file?(input_file)
    end
  end

  def copy_files
    duplicate_files = 0
    total_files = 0
    renamed_files = 0

    enumerate_files(@options[:input_dir]) do |input_file|
      if @duplicate_manager.is_duplicate?(input_file)
        duplicate_files += 1
      else
        output_dir = output_dir(input_file)
        output_file, is_renamed = rename_if_exists(output_file(input_file, output_dir))

        FileUtils.mkdir_p(output_dir) unless File.exists?(output_dir)
        FileUtils.cp input_file, output_file, preserve: true
        FileUtils.chmod 'u=r,go=', output_file
        FileUtils.chown @options[:user], @options[:group], output_file

        @duplicate_manager.register_file(output_file)

        renamed_files += 1 if is_renamed
      end

      total_files += 1
    end

    { duplicate_files: duplicate_files, total_files: total_files, renamed_files: renamed_files }
  end

  def output_dir(input_file)
    change_time = File.ctime(input_file)

    relative_dir = change_time.strftime('%Y-%m-%d')
    File.join(@options[:output_dir], relative_dir)
  end

  def output_file(input_file, output_dir)
    File.join(output_dir, File.basename(input_file))
  end

  def rename_if_exists(output_file)
    file = output_file

    i = 1
    while File.exists?(file)
      file = File.join(File.dirname(output_file), "%03d.%s" % [i, File.basename(output_file)])
      i += 1
    end

    [file, i != 1]
  end

  def is_dot_file?(file)
    File.basename(file).start_with?('.')
  end

end

