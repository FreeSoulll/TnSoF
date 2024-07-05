class LinksController < ApplicationController
  skip_authorization_check

  def destroy
    @link = Link.find(params[:link_id])
    parent = @link.linkable_type.constantize
    parent_id = @link.linkable_id
    resource = parent.find(parent_id)

    if current_user.author_of?(resource)
      @link.delete
    else
      redirect_to resource, notice: "Not author can't delete the #{@link.linkable_type} link"
    end
  end
end
