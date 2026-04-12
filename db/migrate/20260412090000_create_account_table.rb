class CreateAccountTable < ActiveRecord::Migration[8.1]
  def change
    create_table :account do |t|
      t.string :company_name
      t.string :company_website_url
      t.string :company_introduction

      t.timestamps
    end
  end
end
