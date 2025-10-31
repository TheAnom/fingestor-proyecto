require 'bcrypt'

class MigrateUsuarioPasswordToDigest < ActiveRecord::Migration[8.0]
  class Usuario < ApplicationRecord
    self.table_name = 'usuarios'
  end

  def up
    add_column :usuarios, :password_digest, :string unless column_exists?(:usuarios, :password_digest)
    Usuario.reset_column_information

    if column_exists?(:usuarios, :"contraseña")
      say_with_time 'Migrating contrasena to password_digest' do
        Usuario.find_each do |u|
          next unless u.attributes.key?('contraseña')
          raw = u.attributes['contraseña']
          next if raw.blank?
          # Only set digest if not already present
          if u.respond_to?(:password_digest) && (u.password_digest.nil? || u.password_digest.empty?)
            digest = BCrypt::Password.create(raw)
            u.update_columns(password_digest: digest)
          end
        end
      end
      remove_column :usuarios, :"contraseña" if column_exists?(:usuarios, :"contraseña")
    end
  end

  def down
    add_column :usuarios, :"contraseña", :text unless column_exists?(:usuarios, :"contraseña")
    Usuario.reset_column_information
    # We cannot recover raw passwords; leave nils intentionally
    remove_column :usuarios, :password_digest if column_exists?(:usuarios, :password_digest)
  end
end
