class Account < ApplicationRecord
  include ImageAttachmentValidatable

  self.table_name = "account"

  has_one_attached :logo

  validates :company_name, :company_website_url, :company_introduction, presence: true
  validates_image_attachment :logo
end
