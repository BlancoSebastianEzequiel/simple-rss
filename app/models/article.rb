class Article < ApplicationRecord
  belongs_to :feed
  has_many :articles_user
  has_many :users, :through => :articles_user

  validates :link, presence: :true, uniqueness: { case_sensitive: true }
  validates_format_of :link, :with => URI::regexp
end
