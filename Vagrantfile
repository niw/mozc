Vagrant.configure("2") do |config|
  # Ubuntu 12.04
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.provider :virtualbox do |vb|
    # Use USB. Require VirtualBox and Extension Pack.
    vb.customize ["modifyvm", :id, "--usb", "on", "--usbehci", "on"]
  end

  config.vm.provision :puppet
end
