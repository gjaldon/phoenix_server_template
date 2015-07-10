package "nodejs-legacy"
package "npm"
package "git"

%w(/var/repo /var/repo/app.git).each do |path|
  directory path do
    owner "deploy"
    group "deploy"
    action :create
  end
end

execute "install hex" do
  user "deploy"
  cwd "/home/deploy"
  command "HOME=/home/deploy mix local.hex --force"
  creates "/home/deploy/.mix"
  action :run
end

execute "set-up bare git repo" do
  cwd "/var/repo/app.git"
  creates "/var/repo/app.git/config"
  command "git init --bare"
  user "deploy"
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
