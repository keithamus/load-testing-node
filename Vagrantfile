Vagrant.configure("2") do |config|

    config.omnibus.chef_version = :latest

    config.vm.provider :virtualbox do |vb, override|
        override.vm.box = "ubuntu_1204_opscode"
        override.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box"
        override.vm.network :forwarded_port, host: 3000, guest: 3000
        override.vm.network :forwarded_port, host: 3001, guest: 3001
        override.vm.network :forwarded_port, host: 3002, guest: 3002
        override.vm.network :forwarded_port, host: 3003, guest: 3003
        override.vm.network :forwarded_port, host: 3004, guest: 3004
        vb.customize ["modifyvm", :id, "--memory", "4096"]
        vb.customize ["modifyvm", :id, "--vram", "32"]
        vb.customize ["modifyvm", :id, "--cpus", "4"]
    end

    config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = "cookbooks"
        chef.add_recipe "apt"
        chef.add_recipe "nginx"
        chef.add_recipe "nodejs"
        chef.add_recipe "mysite"
        chef.json = {
            "nodejs" => {
                "version" => "0.10.26"
            },
            "mysite" => {
                "application" => {
                    "source_path" => "src",
                    "threads" => 4
                }
            }
        }
        # chef.add_role "web"
    end

end
