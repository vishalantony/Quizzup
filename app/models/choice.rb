class Choice < ApplicationRecord
  belongs_to :question, inverse_of: :choices
  validates :question, presence: true
  validates :choice, presence: true, length: { maximum: 160 }
end
