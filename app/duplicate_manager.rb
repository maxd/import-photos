require 'digest'
require 'pathname'
require 'models/imported_file'

class DuplicateManager

  def initialize(output_dir)
    @output_dir = output_dir
  end

  def is_duplicate?(file)
    sha256 = Digest::SHA256.file(file).hexdigest
    ImportedFile.where(sha256: sha256).limit(1).count != 0
  end

  def register_file(file)
    sha256 = Digest::SHA256.file(file).hexdigest
    relative_file = Pathname(file).relative_path_from(Pathname(@output_dir))

    ImportedFile.create file: relative_file, sha256: sha256
  end

end