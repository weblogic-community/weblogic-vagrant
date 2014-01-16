# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "adminsol" , primary: true do |adminsol|
    adminsol.vm.box = "solaris10-x86_64"
    adminsol.vm.box_url = "https://dl.dropboxusercontent.com/s/an5bthwroh1i8k5/solaris10-x86_64.box"

    adminsol.vm.hostname = "adminsol.example.com"
    # adminsol.vm.network :forwarded_port, guest: 80, host: 8888 ,auto_correct: true
    # adminsol.vm.network :forwarded_port, guest: 7001, host: 7001, auto_correct: true
  
    adminsol.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
  
    adminsol.vm.network :private_network, ip: "10.10.10.10"
  
    # adminsol.vm.network :public_network
    # adminsol.ssh.forward_agent = true
    # adminsol.vm.synced_folder "../data", "/vagrant_data"
  
    adminsol.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--name", "adminsol"]
    end
  
    adminsol.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml"
    
    adminsol.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "site.pp"
      puppet.options           = "--verbose --parser future --hiera_config /vagrant/puppet/hiera.yaml"
  
      puppet.facter = {
        "environment" => "development",
        "vm_type"     => "vagrant",
        "env_app1"    => "application_One",
        "env_app2"    => "application_Two",
   }
      
    end
  
  end
  
  config.vm.define "nodesol1" do |node1|

    node1.vm.box = "solaris10-x86_64"
    node1.vm.box_url = "https://dl.dropboxusercontent.com/s/an5bthwroh1i8k5/solaris10-x86_64.box"
  
    node1.vm.hostname = "nodesol1.example.com"
    #node1.vm.network :forwarded_port, guest: 8002, host: 8002, auto_correct: true
  
    node1.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
  
    node1.vm.network :private_network, ip: "10.10.10.100"
  
    # node1.vm.network :public_network
    # node1.ssh.forward_agent = true
    # node1.vm.synced_folder "../data", "/vagrant_data"
  
    node1.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--name", "nodesol1"]
    end
  
    node1.vm.provision :shell, :inline => "echo '10.10.10.100 nodesol1.example.com nodesol1' >> /etc/hosts ; ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml"
    
    node1.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "node.pp"
      puppet.options           = "--verbose --parser future --hiera_config /vagrant/puppet/hiera.yaml"
  
      puppet.facter = {
        "environment" => "development",
        "vm_type"     => "vagrant",
        "env_app1"    => "application_One",
        "env_app2"    => "application_Two",
      }
      
    end

  end

  config.vm.define "nodesol2" do |node2|

    node2.vm.box = "solaris10-x86_64"
    node2.vm.box_url = "https://dl.dropboxusercontent.com/s/an5bthwroh1i8k5/solaris10-x86_64.box"

    node2.vm.hostname = "nodesol2.example.com"
    #node2.vm.network :forwarded_port, guest: 8001, host: 8001
  
    node2.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
  
    node2.vm.network :private_network, ip: "10.10.10.200", auto_correct: true
  
    # node2.vm.network :public_network
    # node2.ssh.forward_agent = true
    # node2.vm.synced_folder "../data", "/vagrant_data"
  
    node2.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--name", "nodesol2"]
    end
  
    node2.vm.provision :shell, :inline => "echo '10.10.10.200 nodesol2.example.com nodesol2' >> /etc/hosts ; ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml"
    
    node2.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "node.pp"
      puppet.options           = "--verbose --parser future --hiera_config /vagrant/puppet/hiera.yaml"
  
      puppet.facter = {
        "environment" => "development",
        "vm_type"     => "vagrant",
        "env_app1"    => "application_One",
        "env_app2"    => "application_Two",
      }
      
    end

  end


end
