# Apptimize Ve

Builds and populates the ~/apptimize-ve directory.

## OSX

```
cd apptimize-ve
./build.sh
```

## Linux

Use this vagrant file to run on Ubuntu:

```
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4096
    vb.cpus = 2
  end
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    cd /vagrant/
    ./build.sh
  SHELL
end
```

```
vagrant up
```