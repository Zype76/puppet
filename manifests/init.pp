#Base puppet module for hosts managed with foreman
class base () {

  file { '/etc/motd' :
    ensure => present,
    content => puppet:///modules/base/motd.txt, 
  }

  # Set selinux as permissive
  class { selinux:
    mode => 'permissive',
    type => 'targeted',
  }
}
