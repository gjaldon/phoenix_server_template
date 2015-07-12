include_recipe "database::postgresql"

require 'securerandom'

package "nodejs-legacy"
package "npm"
package "git"

file "/etc/profile.d/MIX_ENV.sh" do
  content "export MIX_ENV=prod"
  owner "root"
  group "deploy"
  action :create_if_missing
end

file "/etc/profile.d/SECRET_KEY_BASE.sh" do
  content "export SECRET_KEY_BASE=#{SecureRandom.base64(64)}"
  owner "root"
  group "deploy"
  action :create_if_missing
end

file "/etc/profile.d/DATABASE_URL.sh" do
  content "export DATABASE_URL='postgresql://postgres:test@localhost/postgres_prod'"
  owner "root"
  group "deploy"
  action :create_if_missing
end

file "/etc/profile.d/PORT.sh" do
  content "export PORT=8080"
  owner "root"
  group "deploy"
  mode "0775"
  action :create_if_missing
end

postgresql_database 'postgres_prod' do
  connection(
    :host      => '127.0.0.1',
    :port      => 5432,
    :username  => 'postgres',
    :password  => 'test'
  )
  action :create
end

%w(/var/repo /var/repo/app.git).each do |path|
  directory path do
    owner "deploy"
    group "deploy"
    action :create
  end
end

execute "install hex" do
  user "root"
  group "deploy"
  cwd "#{ENV["HOME"]}"
  command "mix local.hex --force"
  creates "#{ENV["HOME"]}/.mix/archives/hex.ez"
  action :run
end

execute "install rebar" do
  user "root"
  group "deploy"
  cwd "#{ENV["HOME"]}"
  command "mix local.rebar"
  creates "#{ENV["HOME"]}/.mix/rebar"
  action :run
end

execute "set-up bare git repo" do
  cwd "/var/repo/app.git"
  creates "/var/repo/app.git/config"
  command "git init --bare"
  user "deploy"
  group "deploy"
  action :run
end

template "/var/repo/app.git/hooks/post-receive" do
  owner "deploy"
  group "deploy"
  mode "0555"
  source "post-receive.erb"
end

%w(/var/www /var/www/app.com).each do |path|
  directory path do
    owner "deploy"
    group "deploy"
    action :create
  end
end
