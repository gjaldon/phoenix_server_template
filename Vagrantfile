# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "chef-ubuntu-trusty64"
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/me.pub"
  config.vm.provision "shell", inline: "cat ~vagrant/.ssh/me.pub >> ~vagrant/.ssh/authorized_keys"
  config.vm.network :forwarded_port, guest: 80, host: 4567

  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end
end
