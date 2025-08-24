
class Project < ApplicationRecord
  def to_param = slug

  validates :title, :description, :slug, presence: true
  validates :slug, format: { with: /\A[a-z0-9-]+\z/ }, uniqueness: true
  validates :title, length: { maximum: 150 }
  validates :subtitle, length: { maximum: 200 }, allow_blank: true
  validates :description, length: { maximum: 3000 }
end
