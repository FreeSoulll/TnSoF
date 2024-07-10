class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :created_at, :updated_at, :user_id, :rating, :file_urls
  belongs_to :user
  has_many :links
  has_many :comments

  def file_urls
    object.files.map { |file| rails_blob_url(file, host: default_url_options[:host]) }
  end

  private

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end
end
