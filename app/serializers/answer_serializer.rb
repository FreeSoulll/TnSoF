class AnswerSerializer < ActiveModel::Serializer
  include Fileable

  attributes :id, :body, :created_at, :updated_at, :user_id, :rating
  belongs_to :user
  has_many :links
  has_many :comments
end
