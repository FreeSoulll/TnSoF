class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :admin, :created_at, :updated_at

  def file_urls
    object.files.map { |file| rails_blob_url(file, host: default_url_options[:host]) }
  end

  private

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end
end
