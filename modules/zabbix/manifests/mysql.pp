# sudo yum install mysql-server
# sudo systemctl start mysqld
class zabbix::mysql {
  package { 'mysql-repo':
    ensure   => installed,
    provider => rpm,
    source   => 'http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm',
  }
  
  package { 'mysql-server':
    ensure => installed,
    require  => package['mysql-repo'],
}

  service { 'mysqld':
    ensure => running,
    require => package['mysql-server'],
}
  exec { 'mysql-root-password':
    unless => 'mysql -uroot -proot',
    path    => ['/bin', '/usr/bin'],
    command => 'mysqladmin -uroot password root'

  exec { 'create_db':
      unless => 'mysql -uzabbix -pzabbix zabbix',

      path    => ['/bin', '/usr/bin'],
      command  => "mysql -uroot -proot -e \"create database zabbix; grant all on zabbix.* to zabbix@localhost identified by 'zabbix';\"",
      require  => package['mysql-root-password'],
      provider => shell,
  }


