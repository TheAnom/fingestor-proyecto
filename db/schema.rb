# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_01_011500) do
  create_table "asignacion_cursos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "curso_id", null: false
    t.integer "estudiante_id", null: false
    t.integer "nota"
    t.datetime "updated_at", null: false
    t.index ["curso_id"], name: "index_asignacion_cursos_on_curso_id"
    t.index ["estudiante_id", "curso_id"], name: "index_asignacion_unico_estudiante_curso", unique: true
    t.index ["estudiante_id"], name: "index_asignacion_cursos_on_estudiante_id"
  end

  create_table "concepto_pagos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "nombre"
    t.datetime "updated_at", null: false
  end

  create_table "cursos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "nombre"
    t.integer "profesor_id", null: false
    t.datetime "updated_at", null: false
    t.index ["profesor_id"], name: "index_cursos_on_profesor_id"
  end

  create_table "estudiantes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "grado_id", null: false
    t.text "institucion"
    t.text "nombre_completo"
    t.text "telefono"
    t.datetime "updated_at", null: false
    t.index ["grado_id"], name: "index_estudiantes_on_grado_id"
  end

  create_table "grados", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "nombre"
    t.datetime "updated_at", null: false
  end

  create_table "pagos", force: :cascade do |t|
    t.integer "concepto_pago_id", null: false
    t.datetime "created_at", null: false
    t.integer "estudiante_id", null: false
    t.date "fecha"
    t.float "monto"
    t.datetime "updated_at", null: false
    t.integer "usuario_id", null: false
    t.index ["concepto_pago_id"], name: "index_pagos_on_concepto_pago_id"
    t.index ["estudiante_id"], name: "index_pagos_on_estudiante_id"
    t.index ["usuario_id"], name: "index_pagos_on_usuario_id"
  end

  create_table "permiso_rols", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "permiso_id", null: false
    t.integer "rol_id", null: false
    t.datetime "updated_at", null: false
    t.index ["permiso_id"], name: "index_permiso_rols_on_permiso_id"
    t.index ["rol_id"], name: "index_permiso_rols_on_rol_id"
  end

  create_table "permisos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "nombre"
    t.datetime "updated_at", null: false
  end

  create_table "profesors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "nombre"
    t.text "telefono"
    t.datetime "updated_at", null: false
  end

  create_table "rols", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "nombre"
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "api_token"
    t.datetime "created_at", null: false
    t.text "nombre"
    t.string "password_digest"
    t.integer "rol_id", null: false
    t.datetime "updated_at", null: false
    t.index ["api_token"], name: "index_usuarios_on_api_token", unique: true
    t.index ["rol_id"], name: "index_usuarios_on_rol_id"
  end

  add_foreign_key "asignacion_cursos", "cursos"
  add_foreign_key "asignacion_cursos", "estudiantes"
  add_foreign_key "cursos", "profesors"
  add_foreign_key "estudiantes", "grados"
  add_foreign_key "pagos", "concepto_pagos"
  add_foreign_key "pagos", "estudiantes"
  add_foreign_key "pagos", "usuarios"
  add_foreign_key "permiso_rols", "permisos"
  add_foreign_key "permiso_rols", "rols"
  add_foreign_key "usuarios", "rols"
end
