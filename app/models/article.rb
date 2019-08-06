class Article < ApplicationRecord
  belongs_to :feed

  validates :link, presence: :true, uniqueness: { case_sensitive: true }
  validates_format_of :link, :with => URI::regexp
end
