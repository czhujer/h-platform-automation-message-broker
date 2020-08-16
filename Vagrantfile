# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 2.0.0"

Vagrant.configure('2') do |config|
  config.vm.define :"message-broker" do |config_monitoring|
    config_monitoring.vm.box = 'centos/8'

    config_monitoring.vm.provider :libvirt do |v|
      v.memory = 1024
      v.cpus = 2
    end
    dir_message_broker = File.expand_path("..", __FILE__)
    puts "DIR_monitoring: #{dir_message_broker}"

    config_monitoring.vm.hostname = "message-broker"

    config_monitoring.vm.synced_folder dir_message_broker, '/vagrant', type: 'sshfs'

    # run ruby and puppet bootstrap
    config_monitoring.vm.provision :shell, :inline => "echo \"##########################################################\n# starting bootstrap ruby and puppet...\n##########################################################\""
    config_monitoring.vm.provision :shell, path: File.join(dir_message_broker,'scripts/bootstrap_ruby.sh'), :privileged => true
    config_monitoring.vm.provision :shell, path: File.join(dir_message_broker,'scripts/bootstrap_puppet.sh'), :privileged => true

#    # fix PKI
#    config_monitoring.vm.provision :shell, :inline => "echo 'generate pki certs for webserver..'"
#    config_monitoring.vm.provision :shell, path: File.join(dir_monitoring,'scripts/pki-make-dummy-cert.sh'), args: ["localhost"], :privileged => true

    #
    # run r10k and puppet apply
    #
    config_monitoring.vm.provision "r10k-msg",
                                    type: "shell",
                                    :inline => "echo \"##########################################################\n# starting r10k \n##########################################################\""

    config_monitoring.vm.provision "r10k-copy",
                                    type: "shell",
                                    :inline => "cp /vagrant/configs-servers/h-kafka-broker-1/Puppetfile /etc/puppet/Puppetfile",
                                    :privileged => true

    config_monitoring.vm.provision "r10k-run",
                                    type: "shell",
                                    :inline => "cd /etc/puppet && r10k puppetfile install --force --puppetfile /etc/puppet/Puppetfile",
                                    :privileged => true

    config_monitoring.vm.provision "puppet-msg",
                                    type: "shell",
                                    :inline => "echo \"##########################################################\n# starting puppet apply\n##########################################################\""

    config_monitoring.vm.provision "puppet-copy",
                                    type: "shell",
                                    :inline => "cd /vagrant && cp configs-servers/h-kafka-broker-1/*.pp /etc/puppet/manifests/",
                                    :privileged => true

    config_monitoring.vm.provision "puppet-run",
                                    type: "shell",
                                    :inline => "uppet apply --color=false --detailed-exitcodes /etc/puppet/manifests; retval=$?; if [[ $retval -eq 2 ]]; then exit 0; else exit $retval; fi;",
                                    :privileged => true

  end
end
