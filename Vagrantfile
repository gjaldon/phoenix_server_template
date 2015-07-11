# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.ssh.private_key_path = "~/.ssh/id_rsa"
  config.ssh.forward_agent = true
  config.vm.network :forwarded_port, guest: 80, host: 4567

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end
end
