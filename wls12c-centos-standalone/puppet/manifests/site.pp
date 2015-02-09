# test
#
# one machine setup with weblogic 12.1.2
# creates an WLS Domain with JAX-WS (advanced , soap)
# needs jdk7, wls, orautils, fiddyspence-sysctl, erwbgy-limits puppet modules
#

node 'vagrantcentos66' {
  
   include os2, wls12, wls12c_domain, orautils
   Class['os2']  -> Class['wls12'] -> Class['wls12c_domain'] -> Class['orautils']
}

# operating settings for Middleware
class os2 {

  $remove = [ "java-1.7.0-openjdk.x86_64", "java-1.6.0-openjdk.x86_64" ]

  package { $remove:
    ensure  => absent,
  }


  include jdk7

  jdk7::install7{ 'jdk1.7.0_75':
      version              => "7u75" , 
      fullVersion          => "jdk1.7.0_75",
      alternativesPriority => 18000, 
      x64                  => true,
      downloadDir          => "/data/install",
      urandomJavaFix       => true,
      sourcePath           => "/vagrant",
  }


  class { 'limits':
    config => {
               '*'       => {  'nofile'  => { soft => '2048'   , hard => '8192',   },},
               'oracle'  => {  'nofile'  => { soft => '65536'  , hard => '65536',  },
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

  # create a swapfile and it to fstab
  
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
  
  
  # turn off iptables
  
  service { iptables:
        enable    => false,
        ensure    => false,
        hasstatus => true,
  }


}

class wls12{

  $jdkWls12cJDK = 'jdk1.7.0_75'

  $osOracleHome    = "/oracle"
  $osMdwHome       = "/oracle/product/Middleware12c"
  $osWlHome        = "/oracle/product/Middleware12c/wlserver"
  $user            = "oracle"
  $group           = "dba"
  $downloadDir     = "/data/install"

  $puppetDownloadMntPoint = "/vagrant"

  wls::installwls{'wls12c':
    version                => '1212',
    mdwHome                => $osMdwHome,
    oracleHome             => $osOracleHome,
    fullJDKName            => $jdkWls12cJDK, 
    user                   => $user,
    group                  => $group,   
    downloadDir            => $downloadDir,
    puppetDownloadMntPoint => $puppetDownloadMntPoint, 
  }
} 


class wls12c_domain{

  $jdkWls12gJDK    = 'jdk1.7.0_75'

  $wlsDomainName   = "Wls12c"
  $osTemplate      = "standard"

  $adminListenPort = "7001"
  $nodemanagerPort = "5556"
  $address         = "localhost"

  $osOracleHome    = "/oracle"
  $osMdwHome       = "/oracle/product/Middleware12c"
  $osWlHome        = "/oracle/product/Middleware12c/wlserver"

  $user         = "oracle"
  $group        = "dba"
  $downloadDir  = "/data/install"
  $logDir       = "/data/logs" 

  $userConfigDir = '/home/oracle'

  # install domain
  wls::wlsdomain{'wlsDomain12c':
    version         => "1212",
    wlHome          => $osWlHome,
    mdwHome         => $osMdwHome,
    fullJDKName     => $jdkWls12gJDK,  
    user            => $user,
    group           => $group,    
    downloadDir     => $downloadDir, 
    wlsTemplate     => $osTemplate,
    domain          => $wlsDomainName,
    adminListenPort => $adminListenPort,
    nodemanagerPort => $nodemanagerPort,
    wlsUser         => "weblogic",
    password        => "welcome1",
    logDir          => $logDir,
  }

  Wls::Nodemanager {
    wlHome       => $osWlHome,
    fullJDKName  => $jdkWls12gJDK,  
    user         => $user,
    group        => $group,
    serviceName  => $serviceName,  
  }

  #nodemanager starting 
  # in 12c start it after domain creation
  wls::nodemanager{'nodemanager12c':
    version    => "1212",
    listenPort => $nodemanagerPort,
    domain     => $wlsDomainName,     
    require    => Wls::Wlsdomain['wlsDomain12c'],
  }
 
  orautils::nodemanagerautostart{"autostart ${wlsDomainName}":
    version     => "1212",
    wlHome      => $osWlHome, 
    user        => $user,
    domain      => $wlsDomainName,
    logDir      => $logDir,
    require     => Wls::Nodemanager['nodemanager12c'];
  }

  # start AdminServers for configuration
  wls::wlscontrol{'startWLSAdminServer12c':
    wlsDomain     => $wlsDomainName,
    wlsDomainPath => "${osMdwHome}/user_projects/domains/${wlsDomainName}",
    wlsServer     => "AdminServer",
    action        => 'start',
    wlHome        => $osWlHome,
    fullJDKName   => $jdkWls12gJDK,  
    wlsUser       => "weblogic",
    password      => "welcome1",
    address       => $address,
    port          => $nodemanagerPort,
    user          => $user,
    group         => $group,
    downloadDir   => $downloadDir,
    logOutput     => true, 
    require       => Wls::Nodemanager['nodemanager12c'],
  }

  class{'orautils':
    osOracleHomeParam      => $osOracleHome,
    oraInventoryParam      => "${osOracleHome}/oraInventory",
    osDomainTypeParam      => "admin",
    osLogFolderParam       => $logDir,
    osDownloadFolderParam  => $downloadDir,
    osMdwHomeParam         => $osMdwHome,
    osWlHomeParam          => $osWlHome,
    oraUserParam           => $user,
    osDomainParam          => $wlsDomainName,
    osDomainPathParam      => "${osMdwHome}/user_projects/domains/Wls12c",
    nodeMgrPathParam       => "${osMdwHome}/user_projects/domains/Wls12c/bin",
    nodeMgrPortParam       => $nodemanagerPort,
    wlsUserParam           => "weblogic",
    wlsPasswordParam       => "welcome1",
    wlsAdminServerParam    => "AdminServer",
  }
}
