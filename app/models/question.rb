class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_one :best_answer, class_name: 'Answer', dependent: :destroy
  belongs_to :user

  has_many_attached :files

  validates :title, :body, presence: true
end
