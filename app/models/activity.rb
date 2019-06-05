class Activity < ApplicationRecord
  RESULTS = %w[succeed failed].freeze
  CATEGORIES = %w[admin user].freeze

  belongs_to :user
  has_one :target, primary_key: :target_uuid, foreign_key: :uid, class_name: 'User'

  validates :user_ip, presence: true, allow_blank: false
  validates :user_agent, presence: true, trusty_agent: true
  validates :topic, presence: true
  validates :result, presence: true, inclusion: { in: RESULTS }
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validate :target_user

  # this method allows to use all the methods of ::Browser module (platofrm, modern?, version etc)
  def browser
    Browser.new(user_agent)
  end

  private

  def target_user
    errors.add(:target_uuid, :invalid) if target_uuid.present? && User.where(uid: target_uuid).empty?
    errors.add(:target_uuid, :not_allowed) if target_uuid.present? && category.present? && category == 'user' 
  end

  def readonly?
    !new_record?
  end
end
