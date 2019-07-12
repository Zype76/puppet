#Base puppet module for hosts managed with foreman
class puppettest () {

  file { '/etc/motd' :
    ensure => present,
    source => 'puppet:///modules/puppettest/motd.txt', 
  }

  # Set selinux as permissive
  class { selinux:
    mode => 'permissive',
    type => 'targeted',
  }
}
