class prometheus_host () {
  file { '/opt/prometheus' :
    ensure => directory,
  }
  
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
