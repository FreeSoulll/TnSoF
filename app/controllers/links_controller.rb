class LinksController < ApplicationController
  authorize_resource

  def destroy
    @link = Link.find(params[:link_id])
    parent = @link.linkable_type.constantize
    parent_id = @link.linkable_id
    resource = parent.find(parent_id)

    @link.delete
  end
end
