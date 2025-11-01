# Proyecto FinGestor

## Propuesta Inicial

[Acceda a Informacion de Proyecto Inicial](./01_intro/README.md)

## Diseño de Datos

[Acceda a Información de Diseño de Datos](./02_database/README.md)

## Operación y despliegue

### Requisitos

- Ruby y Bundler instalados.
- Base de datos: SQLite local, PostgreSQL en producción.

### Setup local

```
bundle install
bin/rails db:migrate
bin/rails db:seed
bin/rails s
```

### Reportes

- Mensual: `GET /reportes/mensual` con soporte `?desde=&hasta=` y formatos `html,json,csv,pdf`.
- Estado de cuenta: `GET /reportes/estado_cuenta?estudiante_id=` con formatos `html,json,csv,pdf`.

### API interna (v1)

- Autenticación: Header `Authorization: Bearer <api_token>`.
- Endpoints:
  - `GET /api/v1/estudiantes?q=`
  - `GET /api/v1/estudiantes/:id`
  - `GET /api/v1/pagos?desde=&hasta=&concepto_id=&estudiante_id=`

Para obtener token:

```
rails c
u = Usuario.find_by(nombre: 'admin')
u.regenerate_api_token # si no existe
u.api_token
```

### Despliegue Render/Heroku

1) Agregar variables de entorno:

- `DATABASE_URL` (PostgreSQL gestionado)
- `SECRET_KEY_BASE`
- `RAILS_ENV=production`
- `HOST` (dominio público)

2) Procfile ya presente:

```
web: bundle exec puma -C config/puma.rb
```

3) Gemas

- Producción usa `pg`.

4) Migraciones/Seeds en producción

```
bundle exec rails db:migrate
bundle exec rails db:seed