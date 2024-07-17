class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_one :best_answer, class_name: 'Answer', dependent: :destroy
  belongs_to :user
  has_one :award, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions
  has_many :subscribers, through: :subscriptions, source: :user, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :set_subscribe

  scope :last_day, -> { where(created_at: 24.hours.ago..Time.current) }

  private

  def set_subscribe
    subscribe = subscriptions.create(user: user)
    subscribe.save
  end
end
