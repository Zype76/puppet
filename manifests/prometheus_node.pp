class puppettest::prometheus_node () {
  #Create service user and group 
  group { 'nodexport':
    ensure => 'present',
  }
  user { 'nodexport':
    ensure           => 'present',
    gid              => 'nodexport',
    password_max_age => '99999',
    password_min_age => '0',
    shell            => '/bin/bash',
    require          => Group['nodexport'],
  } 

  #Add firewall rules
  exec { 'add firewall port':
    command     => 'firewall\-cmd \-\-zone\=public \-\-permanent \-\-add\-port\=9100\/tcp',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    refreshonly => true,
  }

  exec { 'reload firewall port':
    command     => 'firewall-cmd --reload',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    refreshonly => true,
  }
  
  #Install prometheus node exporter 
  exec { 'wget -P /tmp/ https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz':
    unless  => 'test -f /usr/sbin/node_exporter',
    path    => [ '/usr/bin', '/usr/sbin' ],
  }
  exec { 'tar xvzf /tmp/node_exporter-0.18.1.linux-amd64.tar.gz -C /usr/sbin/ --strip=1':
    creates => '/usr/sbin/node_exporter',
    unless  => 'test -f /usr/sbin/node_exporter',
    path    => [ '/usr/bin', '/usr/sbin' ],
  }
  file { '/lib/systemd/system/node_exporter.service':
    ensure => present,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/puppettest/node_exporter.service'
  }
  
  exec { 'node_exporter-systemd-reload':
    command     => 'systemctl daemon-reload',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    refreshonly => true,
  }
  
  service { 'node_exporter':
    ensure   => running,
    enable   => true,
    provider => systemd,
  }
}
