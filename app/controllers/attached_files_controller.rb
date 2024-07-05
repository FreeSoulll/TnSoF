class AttachedFilesController < ApplicationController
  before_action :set_file, only: [:destroy]

  authorize_resource class: 'ActiveStorage::Attachment'

  def destroy
    record_type = @file.record_type.constantize
    purge_item = record_type.find(params[:question_id] || params[:answer_id])

    @file.purge if current_user.author_of?(purge_item)
  end

  private

  def set_file
    @file = ActiveStorage::Attachment.find(params[:attached_file])
  end
end
