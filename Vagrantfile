# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|


    if Vagrant.has_plugin?('landrush')
        config.landrush.enabled = true
        config.landrush.tld = 'dev'
        config.landrush.guest_redirect_dns = true
        config.landrush.upstream '8.8.8.8'
    end

    config.vm.define 'graphite' do |graphite|
        graphite.vm.box = 'ubuntu/trusty64'
        graphite.vm.hostname = 'graphite.vagrant.dev'
        graphite.vm.network :private_network, type:'dhcp'

        graphite.vm.provision :shell, path: 'graphite/bootstrap.sh'

        graphite.vm.provider 'virtualbox' do |vb|
            vb.memory = 1400
            vb.cpus = 2
            vb.customize ['modifyvm', :id, '--cpuexecutioncap', '50']
        end
    end

    config.vm.define 'statsd' do |statsd|

        statsd.vm.box = 'ubuntu/trusty64'

        statsd.vm.hostname = 'statsd.vagrant.dev'
        statsd.vm.network 'private_network', type: 'dhcp'

        # nodejs startup script
        statsd.vm.provision 'file', source: 'collector/nodejs.conf', destination: '/home/vagrant/nodejs.conf'
        # config to send rolled up metrics to 192.168.33.21, the graphite VM IP.
        statsd.vm.provision 'file', source: 'collector/config.js', destination: '/home/vagrant/config.js'
        # installs node.js, downloads statsd, starts the service
        statsd.vm.provision :shell, path: 'collector/bootstrap.sh'

        statsd.vm.provider 'virtualbox' do |vb|
            vb.memory = 768
            vb.cpus = 1
            vb.customize ['modifyvm', :id, '--cpuexecutioncap', '50']
        end
    end

    config.vm.define 'goapp' do |go_app|

        go_app.vm.box = 'ubuntu/trusty64'

        go_app.vm.hostname = 'goapp.vagrant.dev'
        go_app.vm.network :private_network, type: 'dhcp'

        # golang app startup script
        go_app.vm.provision 'file', source: 'metrics-sender/golang-app.conf', destination: '/home/vagrant/golang-app.conf'
        go_app.vm.provision 'file', source: 'metrics-sender/main', destination: '/home/vagrant/main'

        go_app.vm.provision :shell, path: 'metrics-sender/bootstrap.sh'

        go_app.vm.provider 'virtualbox' do |vb|
            vb.memory = 768
            vb.customize ['modifyvm', :id, '--cpuexecutioncap', '50']
        end

    end 

end
