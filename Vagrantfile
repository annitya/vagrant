Vagrant.configure("2") do |config|

    config.vm.box = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"
    config.vm.network :private_network, ip: "33.33.33.10"
    config.vm.synced_folder ".", "/vagrant", :disabled => true

    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", 4096]
        vb.customize ["modifyvm", :id, "--cpus", "8"]
        vb.customize ["modifyvm", :id, "--vram", "10"]
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", "95"]
    end

    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "manifests"
        puppet.module_path = "modules"
        puppet.manifest_file  = "main.pp"
        puppet.options = "--verbose"
    end

end
