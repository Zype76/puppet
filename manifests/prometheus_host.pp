class prometheus_host () {
  #Create a directory and user for it
  group { 'prometheus':
    ensure => 'present',
  }
  user { 'prometheus':
    ensure           => 'present',
    group            => 'prometheus',
    password_max_age => '99999',
    password_min_age => '0',
    shell            => '/bin/bash',
    require => Group['prometheus'],
  }

  file { '/opt/prometheus' :
    ensure => directory,
    owner  => 'prometheus',
    require => User['prometheus'],
  }

  #Install prometheus and configure service
  exec { 'wget -P /tmp/ https://github.com/prometheus/prometheus/releases/download/v2.12.0/prometheus-2.12.0.linux-amd64.tar.gz':
    creates => '/root/alreadydonelel',
    path    => ['/usr/bin', '/usr/sbin',],
  }
  
  exec { 'tar xvzf /tmp/prometheus-2.12.0.linux-amd64.tar.gz -C /opt/prometheus':
    creates => '/root/alreadydonelel2',
    path    => ['/usr/bin', '/usr/sbin',],
  }
  
  file { '/lib/systemd/system/prometheus.service':
    ensure => present,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/puppettest/prometheus.service'
  }
  
  exec { 'myservice-systemd-reload':
    command     => 'systemctl daemon-reload',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    refreshonly => true,
  }
  
  service { 'prometheus':
    ensure   => running,
    enable   => true,
    provider => systemd,
  }
}
