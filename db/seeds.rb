# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

roles = ["administrador", "suplente", "consultor"]
roles.each { |r| Rol.find_or_create_by!(nombre: r) }

admin_role = Rol.find_by!(nombre: "administrador")
admin = Usuario.find_or_create_by!(nombre: "admin") do |u|
  u.rol = admin_role
  u.password = "Admin1234"
end

# Ensure admin has API token
admin ||= Usuario.find_by!(nombre: "admin")
admin.regenerate_api_token if admin.api_token.blank?

# Demo users for other roles
suplente_role = Rol.find_by(nombre: "suplente")
if suplente_role
  Usuario.find_or_create_by!(nombre: "suplente1") do |u|
    u.rol = suplente_role
    u.password = "Suplente1234"
  end
end

consultor_role = Rol.find_by(nombre: "consultor")
if consultor_role
  Usuario.find_or_create_by!(nombre: "consultor1") do |u|
    u.rol = consultor_role
    u.password = "Consultor1234"
  end
end
