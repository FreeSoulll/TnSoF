module Fileable
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  included do
    attributes :file_urls
  end

  def file_urls
    object.files.map { |file| rails_blob_url(file, host: Rails.application.config.action_mailer.default_url_options[:host]) }
  end
end
