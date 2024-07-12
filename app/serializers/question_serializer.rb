class QuestionSerializer < ActiveModel::Serializer
  include Fileable

  attributes :id, :title, :body, :created_at, :updated_at, :user_id, :short_title
  has_many :answers
  belongs_to :user
  has_many :links
  has_many :comments

  def short_title
    object.title.truncate(7)
  end
end
