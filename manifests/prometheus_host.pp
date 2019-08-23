class puppettest::prometheus_host () {
  #Create a directory and user for it
  group { 'prometheus':
    ensure => 'present',
  }
  user { 'prometheus':
    ensure           => 'present',
    gid            => 'prometheus',
    password_max_age => '99999',
    password_min_age => '0',
    shell            => '/bin/bash',
    require => Group['prometheus'],
  }

  #Disable firewalld (only run this on a secure private network!)
  service { 'firewalld':
    ensure   => stopped,
    enable   => false,
    provider => systemd,
  }

  #Create required directories
  file { [ '/opt/prometheus', '/var/lib/prometheus', '/var/lib/prometheus/data' ]:
    ensure => directory,
    owner  => 'prometheus',
    require => User['prometheus'],
  }

  #Install prometheus and configure service
  exec { 'wget -P /tmp/ https://github.com/prometheus/prometheus/releases/download/v2.12.0/prometheus-2.12.0.linux-amd64.tar.gz':
    creates => '/tmp/prometheus-2.12.0.linux-amd64.tar.gz',
    path    => ['/usr/bin', '/usr/sbin',],
  }
  
  exec { 'tar xvzf /tmp/prometheus-2.12.0.linux-amd64.tar.gz -C /opt/prometheus --strip=1':
    creates => '/opt/prometheus/prometheus',
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
