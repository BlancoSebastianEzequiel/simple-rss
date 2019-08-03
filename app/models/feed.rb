class Feed < ApplicationRecord
  has_and_belongs_to_many :user

  validates :url, presence: :true, uniqueness: { case_sensitive: true }
  validates_format_of :url, :with => URI::regexp
end
