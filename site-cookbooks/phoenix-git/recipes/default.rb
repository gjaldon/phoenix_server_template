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
