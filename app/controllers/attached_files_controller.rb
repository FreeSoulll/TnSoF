class AttachedFilesController < ApplicationController
  before_action :set_file, only: [:destroy]

  def destroy
    @file.purge
  end

  private

  def set_file
    parent = params[:question_id].present? ? Question : Answer
    @file = parent.find(params["#{parent.name.downcase}_id"]).files.find(params[:attached_file])
  end
end
