Vagrant.configure("1") do |config|

  config.vm.define "ci" do |ci|
    ci.vm.box = "geerlingguy/centos7"
    # ci.vm.box_check_update = true
    ci.vm.network "private_network", ip: "192.168.33.13"

    ci.vm.provision "shell", inline: <<-SHELL
      if ! rpm -qa | grep ansible; then
        sudo yum -y install epel-release
        sudo yum -y install ansible
      fi
      ansible-playbook /vagrant/ansible/provision.yml
    SHELL
  end
end