#Base puppet module for hosts managed with foreman
class puppettest () {

  file { '/etc/motd' :
    ensure => present,
    source => 'puppet:///modules/puppettest/motd.txt', 
  }

  #Install default packages
  package { [ 'screen', 'parted', 'net-tools', 'lsscsi', 'nmap', 'wget', 'htop', 'curl', 'open-vm-tools', 'git', 'firewalld']:
      ensure => 'installed' 
  }

  # Set selinux as permissive
  class { selinux:
    mode => 'permissive',
    type => 'targeted',
  }
  # Install prometheus
  if $prometheus == 'yes'{
    class { puppettest::prometheus_host: }
  }

  # Install prometheus
  if $monitorme == 'yes'{
    class { puppettest::prometheus_node: }
  }

}
