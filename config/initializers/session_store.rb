Rails.application.config.session_store :cookie_store,
  key: '_sistema_session',
  secure: Rails.env.production?,
  httponly: true,
  same_site: :strict
