server 'orcheya.com', user: "deploy", roles: %w{app db web}, port: 28826

set :application, 'orcheya'
set :branch, 'master'
set :deploy_to, '/srv/orcheya'
set :rails_env, 'production'
set :keep_releases, 5
set :nginx_domains, 'orcheya.com'
set :nginx_use_ssl, true
set :nginx_ssl_certificate_path, '/etc/nginx/certs'
set :nginx_ssl_certificate_key_path, '/etc/nginx/certs'
set :nginx_ssl_certificate, 'letsencrypt-orcheya.pem'
set :nginx_ssl_certificate_key, 'letsencrypt-orcheya.key'

set :nginx_application_name, "#{fetch :application}"
set :nginx_template, "#{stage_config_path}/templates/nginx.conf.erb"
set :app_server_socket, "#{shared_path}/tmp/sockets/puma.sock"
set :disallow_pushing, true

append :linked_files, 'config/database.yml', 'config/secrets.yml', 'config/credentials/production.key'
