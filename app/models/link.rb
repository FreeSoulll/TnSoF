class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  validates :name, :url, presence: true
  validates :url, format: { with: /\A(?:https?|ftp):\/\/[\w\-]+(?:\.[\w\-]+)+[\/#?]?.*?\b\z/, message: 'Enter correct url' }

  def gist?
    url =~ /gist\.github\.com/
  end

  def gist_token
    url.split('/').last
  end
end
