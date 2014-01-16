# test
#
# one machine setup with weblogic 12.1.2
# creates an WLS Domain with JAX-WS (advanced, soap over jms)
# needs jdksolaris, orawls, orautils
#

node 'nodesol1.example.com', 'nodesol2.example.com' {
  
  include os, ssh
  include java, orawls::weblogic, opatch, orautils, copydomain, nodemanager

  Class['java'] -> Class['orawls::weblogic'] 
}

# operating settings for Middleware
class os {

  notify { "class os ${operatingsystem}":} 

  $default_params = {}
  $host_instances = hiera('hosts', [])
  create_resources('host',$host_instances, $default_params)

  group { 'dba' :
    ensure => present,
  }

  # http://raftaman.net/?p=1311 for generating password
  user { 'oracle' :
    ensure     => present,
    groups     => 'dba',
    shell      => '/bin/bash',
    password   => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
    home       => "/export/home/oracle",
    comment    => 'Oracle user created by Puppet',
    managehome => true,
    require    => Group['dba'],
  }
  $execPath     = "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"

  exec { "projadd max-shm-memory":
    command => "projadd -p 102  -c 'ORAWLS' -U oracle -G dba  -K 'project.max-shm-memory=(privileged,2G,deny)' ORAWLS",
    require => [ User["oracle"],
#                 Package['SUNWi1of'],
#                 Package[$install],
               ],
    unless  => "projects -l | grep -c ORAWLS",           
    path    => $execPath,
  }

  exec { "projmod default max-shm-memory":
    command     => "projmod -s -K 'project.max-shm-memory=(privileged,2G,deny)' default",
    require     => Exec["projadd max-shm-memory"],
    subscribe   => Exec["projadd max-shm-memory"],
    refreshonly => true, 
    path        => $execPath,
  }  

  exec { "projmod default max-file-descriptor":
    command     => "projmod -s -K 'process.max-file-descriptor=(basic,65536,deny)' default",
    require     => Exec["projmod default max-shm-memory"],
    subscribe   => Exec["projmod default max-shm-memory"],
    refreshonly => true, 
    path        => $execPath,
  }

  exec { "projmod max-sem-ids":
    command     => "projmod -s -K 'project.max-sem-ids=(privileged,100,deny)' ORAWLS",
    subscribe   => Exec["projmod default max-file-descriptor"],
    require     => Exec["projmod default max-file-descriptor"],
    refreshonly => true, 
    path        => $execPath,
  }

  exec { "projmod max-shm-ids":
    command     => "projmod -s -K 'project.max-shm-ids=(privileged,100,deny)' ORAWLS",
    require     => Exec["projmod max-sem-ids"],
    subscribe   => Exec["projmod max-sem-ids"],
    refreshonly => true, 
    path        => $execPath,
  }

  exec { "projmod max-sem-nsems":
    command     => "projmod -s -K 'process.max-sem-nsems=(privileged,256,deny)' ORAWLS",
    require     => Exec["projmod max-shm-ids"],
    subscribe   => Exec["projmod max-shm-ids"],
    refreshonly => true, 
    path        => $execPath,
  }

  exec { "projmod max-file-descriptor":
    command     => "projmod -s -K 'process.max-file-descriptor=(basic,65536,deny)' ORAWLS",
    require     => Exec["projmod max-sem-nsems"],
    subscribe   => Exec["projmod max-sem-nsems"],
    refreshonly => true, 
    path        => $execPath,
  }

  exec { "projmod max-stack-size":
    command     => "projmod -s -K 'process.max-stack-size=(privileged,32MB,deny)' ORAWLS",
    require     => Exec["projmod max-file-descriptor"],
    subscribe   => Exec["projmod max-file-descriptor"],
    refreshonly => true, 
    path        => $execPath,
  }

  exec { "usermod oracle":
    command     => "usermod -K project=ORAWLS oracle",
    require     => Exec["projmod max-stack-size"],
    subscribe   => Exec["projmod max-stack-size"],
    refreshonly => true, 
    path        => $execPath,
  }

  exec { "ndd 1":
    command => "ndd -set /dev/tcp tcp_smallest_anon_port 9000",
    require => Exec["usermod oracle"],
    path    => $execPath,
  }
  exec { "ndd 2":
    command => "ndd -set /dev/tcp tcp_largest_anon_port 65500",
    require => Exec["ndd 1"],
    path    => $execPath,
  }

  exec { "ndd 3":
    command => "ndd -set /dev/udp udp_smallest_anon_port 9000",
    require => Exec["ndd 2"],
    path    => $execPath,
  }

  exec { "ndd 4":
    command => "ndd -set /dev/udp udp_largest_anon_port 65500",
    require => Exec["ndd 3"],
    path    => $execPath,
  }    

  exec { "ulimit -S":
    command => "ulimit -S -n 4096",
    require => Exec["ndd 4"],
    path    => $execPath,
  }

  exec { "ulimit -H":
    command => "ulimit -H -n 65536",
    require => Exec["ulimit -S"],
    path    => $execPath,
  }  




}

class ssh {
  require os

  file { "/export/home/oracle/.ssh/":
    owner  => "oracle",
    group  => "dba",
    mode   => "700",
    ensure => "directory",
    alias  => "oracle-ssh-dir",
  }
  
  file { "/export/home/oracle/.ssh/id_rsa.pub":
    ensure  => present,
    owner   => "oracle",
    group   => "dba",
    mode    => "644",
    source  => "/vagrant/ssh/id_rsa.pub",
    require => File["oracle-ssh-dir"],
  }
  
  file { "/export/home/oracle/.ssh/id_rsa":
    ensure  => present,
    owner   => "oracle",
    group   => "dba",
    mode    => "600",
    source  => "/vagrant/ssh/id_rsa",
    require => File["oracle-ssh-dir"],
  }
  
  file { "/export/home/oracle/.ssh/authorized_keys":
    ensure  => present,
    owner   => "oracle",
    group   => "dba",
    mode    => "644",
    source  => "/vagrant/ssh/id_rsa.pub",
    require => File["oracle-ssh-dir"],
  }        
}


class java {
  require os

  notice 'class java'

  jdksolaris::install7{'jdk1.7.0_45':
    version              => '7u45',
    fullVersion          => 'jdk1.7.0_45',
    x64                  => true,
    downloadDir          => '/data/install',
    sourcePath           => "/vagrant",
  }  


}

class opatch{
  require orawls::weblogic

  notice 'class opatch'
  $default_params = {}
  $opatch_instances = hiera('opatch_instances', [])
  create_resources('orawls::opatch',$opatch_instances, $default_params)
}


class copydomain {
  require orawls::weblogic, opatch


  notify { 'class copydomain':} 
  $default_params = {}
  $copy_instances = hiera('copy_instances', [])
  create_resources('orawls::copydomain',$copy_instances, $default_params)

}


class nodemanager {
  require orawls::weblogic, opatch, copydomain

  notify { 'class nodemanager':} 
  $default_params = {}
  $nodemanager_instances = hiera('nodemanager_instances', [])
  create_resources('orawls::nodemanager',$nodemanager_instances, $default_params)
}