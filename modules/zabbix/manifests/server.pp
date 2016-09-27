class zabbix::server {
  
  package {'httpd':
    name   => 'httpd',
    ensure => installed,  
  }

 # yumrepo { 'zabbix':
 #   ensure   => installed,
 #   baseurl  => 'http://repo.zabbix.com/zabbix/2.4/rhel/6/$basearch/',
 #   descr    => 'Zabbix Official Repository - $basearch',
 #   enabled  => '1',
 #   gpgcheck => '1',
 #   gpgkey   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
 #   require  => package['httpd'],
 # }
  package { 'zabbix-server-mysql': 
    name    => 'zabbix-server-mysql',
    ensure  => installed,
    require =>  package['httpd'],
  }

  package { 'zabbix-web-mysql':
    name    => 'zabbix-web-mysql',
    ensure  => installed,
    require => package['zabbix-server-mysql'],
  }

  package { 'zabbix-agent':
    name    => 'zabbix-agent',
    ensure  => installed,
    require => package['zabbix-web-mysql'],
  }
 # package { 'mysql-community-release-el7-5.noarch':
 #   ensure   => 'installed',
 #   provider => rpm,
 #   source   => 'http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm',
 #   require => package['zabbix-web-mysql'],
 # } 
  
  package { 'mysql-server':
    ensure => installed,
    require  => package['zabbix-web-mysql'],
}

  service { 'mysqld':
    ensure => running,
    require => package['mysql-server'],
#require => package['zabbix-web-mysql'],
    enable  => 'true',
}

  exec { 'mysqladmin -uroot password root':
    unless => 'mysql -uroot -proot',
    path    => ['/bin', '/usr/bin'],
    require => service['mysqld'],
}

  exec { "mysql -uroot -proot -e \"create database zabbix; grant all on zabbix.* to zabbix@localhost identified by 'zabbix';\"":
    unless => 'mysql -uzabbix -pzabbix zabbix',
    path    => ['/bin', '/usr/bin'],
    require => exec['mysqladmin -uroot password root'],
}
 exec {'mysql -uroot -proot zabbix < /usr/share/doc/zabbix-server-mysql-2.4.8/create/schema.sql; mysql -uroot -proot zabbix < /usr/share/doc/zabbix-server-mysql-2.4.8/create/images.sql; mysql -uroot -proot zabbix < /usr/share/doc/zabbix-server-mysql-2.4.8/create/data.sql':
  path    => ['/bin', '/usr/bin'],
  require => exec["mysql -uroot -proot -e \"create database zabbix; grant all on zabbix.* to zabbix@localhost identified by 'zabbix';\""],
}
 
  file { '/etc/zabbix/zabbix_server.conf ':
      content => template('zabbix/zabbix_server.conf.erb'),
      owner   => root,
      group   => zabbix,
      mode    => '0640',
      require => package['zabbix-agent'],
      }

  file { '/etc/httpd/conf.d/zabbix.conf':
      content => template('zabbix/zabbix.conf.erb'),
      owner   => root,
      group   => root,
      mode    => '0644',
      require => package['zabbix-agent'],
      }

  service { 'zabbix-server':
    ensure => running,
    require => exec['mysqladmin -uroot password root'],
    enable  => 'true',
}

  service { 'zabbix-agent':
    ensure => running,
    require => service['zabbix-server'],
    enable  => 'true',
}

  service { 'httpd':
    ensure => running,
    require => service['zabbix-server'],
    enable  => 'true',
}
}
