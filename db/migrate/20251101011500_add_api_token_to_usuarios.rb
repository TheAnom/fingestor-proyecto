class AddApiTokenToUsuarios < ActiveRecord::Migration[8.1]
  def change
    add_column :usuarios, :api_token, :string
    add_index :usuarios, :api_token, unique: true
  end
end
