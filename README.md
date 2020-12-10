# Apptimize Ve

Builds and populates the ~/apptimize-ve directory.

## OSX

### Synthetic Directories

Create the following directories in your home folder.
```shell script
mkdir -p ~/apptimize-ve/ave
mkdir -p ~/apptimize-ve/data
mkdir -p ~/apptimize-ve/ios
```

Add writable links to apptimize folders in root volume in Catalina.
```shell script
sudo touch /etc/synthetic.conf
echo "ave\t${HOME}/apptimize-ve/ave" | sudo tee -a /etc/synthetic.conf
echo "data\t${HOME}/apptimize-ve/data" | sudo tee -a /etc/synthetic.conf
echo "ios\t${HOME}/apptimize-ve/ios" | sudo tee -a /etc/synthetic.conf
```

**Reboot**

### Build

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