class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  has_many :items, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :drinking_records, dependent: :destroy
  has_many :user_items, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :user_stamps
  has_many :stamps, through: :user_stamps

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def own?(object)
    id == object.user_id
  end
end
