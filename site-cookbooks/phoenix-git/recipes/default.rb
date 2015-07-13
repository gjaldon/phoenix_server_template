include_recipe "database::postgresql"

require 'securerandom'

package "nodejs-legacy"
package "npm"
package "git"

file "/etc/profile.d/MIX_ENV.sh" do
  content "export MIX_ENV=#{node['phoenix-git']['mix_env']}"
  owner "root"
  group "sysadmin"
  action :create_if_missing
end

file "/etc/profile.d/SECRET_KEY_BASE.sh" do
  content "export SECRET_KEY_BASE=#{SecureRandom.base64(64)}"
  owner "root"
  group "sysadmin"
  action :create_if_missing
end

db_conn = node['phoenix-git']['db_connection']
database_url = "postgresql://#{db_conn[:username]}:#{db_conn[:password]}@#{db_conn[:host]}/#{node['phoenix-git']['db_name']}"

file "/etc/profile.d/DATABASE_URL.sh" do
  content "export DATABASE_URL='#{database_url}'"
  owner "root"
  group "sysadmin"
  action :create_if_missing
end

file "/etc/profile.d/PORT.sh" do
  content "export PORT=#{node['phoenix-git']['app_port_1']}"
  owner "root"
  group "sysadmin"
  mode "0775"
  action :create_if_missing
end

postgresql_database node['phoenix-git']['db_name'] do
  connection(node['phoenix-git']['db_connection'])
  action :create
end

%W(/var/repo /var/repo/#{node['phoenix-git']['app_name']}.git).each do |path|
  directory path do
    owner "deploy"
    group "sysadmin"
    action :create
  end
end

execute "set-up bare git repo" do
  cwd "/var/repo/#{node['phoenix-git']['app_name']}.git"
  creates "/var/repo/#{node['phoenix-git']['app_name']}.git/config"
  command "git init --bare"
  user "deploy"
  group "sysadmin"
  action :run
end

template "/var/repo/#{node['phoenix-git']['app_name']}.git/hooks/post-receive" do
  owner "deploy"
  group "sysadmin"
  mode "0555"
  source "post-receive.erb"
end

%W(/var/www /var/www/#{node['phoenix-git']['app_name']}.com).each do |path|
  directory path do
    owner "deploy"
    group "sysadmin"
    action :create
  end
end
