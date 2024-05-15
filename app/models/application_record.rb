class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def new_files=(files)
    self.files.attach(files)
  end
end
