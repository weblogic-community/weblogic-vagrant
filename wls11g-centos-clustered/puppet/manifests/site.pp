# test
#
# one machine setup with weblogic 10.3.6 with BSU
# needs jdk7, orawls, orautils, fiddyspence-sysctl, erwbgy-limits puppet modules
#

node 'admin.example.com' {
  
  include os, ssh, java
  include orawls::weblogic, orautils
  include bsu
  include domains, nodemanager, startwls, userconfig
  include machines
  include managed_servers
  include clusters
  include jms_servers
  include jms_saf_agents
  include jms_modules
  include jms_module_subdeployments
  include jms_module_quotas
  include jms_module_cfs
  include jms_module_objects_errors
  include jms_module_queues_objects
  include jms_module_topics_objects
  include jms_module_foreign_server_objects,jms_module_foreign_server_entries_objects
  include pack_domain

  Class[java] -> Class[orawls::weblogic]
}  

# operating settings for Middleware
class os {

  notice "class os ${operatingsystem}"

  $default_params = {}
  $host_instances = hiera('hosts', [])
  create_resources('host',$host_instances, $default_params)

  exec { "create swap file":
    command => "/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=8192",
    creates => "/var/swap.1",
  }

  exec { "attach swap file":
    command => "/sbin/mkswap /var/swap.1 && /sbin/swapon /var/swap.1",
    require => Exec["create swap file"],
    unless => "/sbin/swapon -s | grep /var/swap.1",
  }

  #add swap file entry to fstab
  exec {"add swapfile entry to fstab":
    command => "/bin/echo >>/etc/fstab /var/swap.1 swap swap defaults 0 0",
    require => Exec["attach swap file"],
    user => root,
    unless => "/bin/grep '^/var/swap.1' /etc/fstab 2>/dev/null",
  }

  service { iptables:
        enable    => false,
        ensure    => false,
        hasstatus => true,
  }

  group { 'dba' :
    ensure => present,
  }

  # http://raftaman.net/?p=1311 for generating password
  # password = oracle
  user { 'wls' :
    ensure     => present,
    groups     => 'dba',
    shell      => '/bin/bash',
    password   => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
    home       => "/home/wls",
    comment    => 'wls user created by Puppet',
    managehome => true,
    require    => Group['dba'],
  }

  $install = [ 'binutils.x86_64','unzip.x86_64']


  package { $install:
    ensure  => present,
  }

  class { 'limits':
    config => {
               '*'       => {  'nofile'  => { soft => '2048'   , hard => '8192',   },},
               'wls'     => {  'nofile'  => { soft => '65536'  , hard => '65536',  },
                               'nproc'   => { soft => '2048'   , hard => '16384',   },
                               'memlock' => { soft => '1048576', hard => '1048576',},
                               'stack'   => { soft => '10240'  ,},},
               },
    use_hiera => false,
  }

  sysctl { 'kernel.msgmnb':                 ensure => 'present', permanent => 'yes', value => '65536',}
  sysctl { 'kernel.msgmax':                 ensure => 'present', permanent => 'yes', value => '65536',}
  sysctl { 'kernel.shmmax':                 ensure => 'present', permanent => 'yes', value => '2588483584',}
  sysctl { 'kernel.shmall':                 ensure => 'present', permanent => 'yes', value => '2097152',}
  sysctl { 'fs.file-max':                   ensure => 'present', permanent => 'yes', value => '6815744',}
  sysctl { 'net.ipv4.tcp_keepalive_time':   ensure => 'present', permanent => 'yes', value => '1800',}
  sysctl { 'net.ipv4.tcp_keepalive_intvl':  ensure => 'present', permanent => 'yes', value => '30',}
  sysctl { 'net.ipv4.tcp_keepalive_probes': ensure => 'present', permanent => 'yes', value => '5',}
  sysctl { 'net.ipv4.tcp_fin_timeout':      ensure => 'present', permanent => 'yes', value => '30',}
  sysctl { 'kernel.shmmni':                 ensure => 'present', permanent => 'yes', value => '4096', }
  sysctl { 'fs.aio-max-nr':                 ensure => 'present', permanent => 'yes', value => '1048576',}
  sysctl { 'kernel.sem':                    ensure => 'present', permanent => 'yes', value => '250 32000 100 128',}
  sysctl { 'net.ipv4.ip_local_port_range':  ensure => 'present', permanent => 'yes', value => '9000 65500',}
  sysctl { 'net.core.rmem_default':         ensure => 'present', permanent => 'yes', value => '262144',}
  sysctl { 'net.core.rmem_max':             ensure => 'present', permanent => 'yes', value => '4194304', }
  sysctl { 'net.core.wmem_default':         ensure => 'present', permanent => 'yes', value => '262144',}
  sysctl { 'net.core.wmem_max':             ensure => 'present', permanent => 'yes', value => '1048576',}

}

class ssh {
  require os

  notice 'class ssh'

  file { "/home/wls/.ssh/":
    owner  => "wls",
    group  => "dba",
    mode   => "700",
    ensure => "directory",
    alias  => "wls-ssh-dir",
  }
  
  file { "/home/wls/.ssh/id_rsa.pub":
    ensure  => present,
    owner   => "wls",
    group   => "dba",
    mode    => "644",
    source  => "/vagrant/ssh/id_rsa.pub",
    require => File["wls-ssh-dir"],
  }
  
  file { "/home/wls/.ssh/id_rsa":
    ensure  => present,
    owner   => "wls",
    group   => "dba",
    mode    => "600",
    source  => "/vagrant/ssh/id_rsa",
    require => File["wls-ssh-dir"],
  }
  
  file { "/home/wls/.ssh/authorized_keys":
    ensure  => present,
    owner   => "wls",
    group   => "dba",
    mode    => "644",
    source  => "/vagrant/ssh/id_rsa.pub",
    require => File["wls-ssh-dir"],
  }        
}

class java {
  require os

  notice 'class java'

  $remove = [ "java-1.7.0-openjdk.x86_64", "java-1.6.0-openjdk.x86_64" ]

  package { $remove:
    ensure  => absent,
  }

  include jdk7

  jdk7::install7{ 'jdk1.7.0_45':
      version              => "7u45" , 
      fullVersion          => "jdk1.7.0_45",
      alternativesPriority => 18000, 
      x64                  => true,
      downloadDir          => "/data/install",
      urandomJavaFix       => true,
      sourcePath           => "/software",
  }

}


class bsu{
  require orawls::weblogic

  notice 'class bsu'
  $default_params = {}
  $bsu_instances = hiera('bsu_instances', [])
  create_resources('orawls::bsu',$bsu_instances, $default_params)
}

class domains{
  require orawls::weblogic, bsu

  notice 'class domains'
  $default_params = {}
  $domain_instances = hiera('domain_instances', [])
  create_resources('orawls::domain',$domain_instances, $default_params)
}

class nodemanager {
  require orawls::weblogic, domains

  notify { 'class nodemanager':} 
  $default_params = {}
  $nodemanager_instances = hiera('nodemanager_instances', [])
  create_resources('orawls::nodemanager',$nodemanager_instances, $default_params)
}

class startwls {
  require orawls::weblogic, domains,nodemanager


  notify { 'class startwls':} 
  $default_params = {}
  $control_instances = hiera('control_instances', [])
  create_resources('orawls::control',$control_instances, $default_params)
}

class userconfig{
  require orawls::weblogic, domains, nodemanager, startwls 

  notify { 'class userconfig':} 
  $default_params = {}
  $userconfig_instances = hiera('userconfig_instances', [])
  create_resources('orawls::storeuserconfig',$userconfig_instances, $default_params)
} 

class machines{
  require userconfig

  notify { 'class machines':} 
  $default_params = {}
  $machines_instances = hiera('machines_instances', [])
  create_resources('orawls::wlstexec',$machines_instances, $default_params)
}


define wlst_yaml()
{
  $type            = $title
  $apps            = hiera('weblogic_apps')
  $apps_config_dir = hiera('apps_config_dir')

  $apps.each |$app| { 
    $allHieraEntriesYaml = loadyaml("${apps_config_dir}/${app}/${type}/${app}_${type}.yaml")
    if $allHieraEntriesYaml != undef {
      if $allHieraEntriesYaml["${type}_instances"] != undef {
        orawls::utils::wlstbulk{ "${type}_instances_${app}":
          entries_array => $allHieraEntriesYaml["${type}_instances"],
        }
      }  
    }
  }  
}

class managed_servers{
  require machines
  notify { 'class managed_servers':} 
  wlst_yaml{'servers':} 
}

class clusters{
  require managed_servers
  notify { 'class clusters':} 
  wlst_yaml{'clusters':} 
}

define wlst_jms_yaml()
{
  $type            = $title
  $apps            = hiera('weblogic_apps')
  $apps_config_dir = hiera('apps_config_dir')

  $apps.each |$app| { 
    $allHieraEntriesYaml = loadyaml("${apps_config_dir}/${app}/jms/${type}/${app}_${type}.yaml")
    if $allHieraEntriesYaml != undef {
      if $allHieraEntriesYaml["${type}_instances"] != undef {
        orawls::utils::wlstbulk{ "jms_${type}_instances_${app}":
          entries_array => $allHieraEntriesYaml["${type}_instances"],
        }
      }  
    }
  }  
}

class jms_servers{
  require clusters
  notify { 'class jms_servers':} 
  wlst_jms_yaml{'servers':} 
}

class jms_saf_agents{
  require jms_servers
  notify { 'class jms_saf_agents':} 
  wlst_jms_yaml{'saf_agents':} 
}

class jms_modules{
  require jms_saf_agents
  notify { 'class jms_modules':} 
  wlst_jms_yaml{'modules':} 
}

class jms_module_subdeployments{
  require jms_modules
  notify { 'class jms_module_subdeployments':} 
  wlst_jms_yaml{'subdeployments':} 
}

class jms_module_quotas{
  require jms_module_subdeployments
  notify { 'class jms_module_quotas':} 
  wlst_jms_yaml{'quotas':} 
}

class jms_module_cfs{
  require jms_module_quotas
  notify { 'class jms_module_cfs':} 
  wlst_jms_yaml{'cf':} 
}

class jms_module_objects_errors{
  require jms_module_cfs
  notify { 'class jms_module_objects_errors':} 
  wlst_jms_yaml{'error_queues':} 
}

class jms_module_queues_objects{
  require jms_module_objects_errors
  notify { 'class jms_module_queues_objects':} 
  wlst_jms_yaml{'queues':} 
}

class jms_module_topics_objects{
  require jms_module_queues_objects
  notify { 'class jms_module_topics_objects':} 
  wlst_jms_yaml{'topics':} 
}


class jms_module_foreign_server_objects{
  require jms_module_topics_objects
  notify { 'class jms_module_foreign_server_objects':} 
  wlst_jms_yaml{'foreign_servers':} 
}

class jms_module_foreign_server_entries_objects{
  require jms_module_foreign_server_objects
  notify { 'class jms_module_foreign_server_entries_objects':} 
  wlst_jms_yaml{'foreign_servers_objects':} 
}

class pack_domain{
  require jms_module_foreign_server_entries_objects

  notify { 'class pack_domain':} 
  $default_params = {}
  $pack_domain_instances = hiera('pack_domain_instances', $default_params)
  create_resources('orawls::packdomain',$pack_domain_instances, $default_params)
}

