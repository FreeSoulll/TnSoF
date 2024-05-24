class LinksController < ApplicationController
  def destroy
    @link = Link.find(params[:link_id])
    parent = @link.linkable_type.constantize
    parent_id = @link.linkable_id

    @link.delete if current_user.author_of?(parent.find(parent_id))
  end
end
