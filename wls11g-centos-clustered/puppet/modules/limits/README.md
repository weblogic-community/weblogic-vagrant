# puppet-limits

Puppet module to set entries in /etc/security/limits.conf

## limits

The recommended usage is to place the configuration under a limits hash in
hiera and just include the limits module in your puppet configuration:

    include limits

Example hiera config:

    limits:
      '*':
        nofile:
          soft: '2048'
          hard: '8192'
        nproc:
          soft: '20'
          hard: '20'
      'myuser':
        nofile:
          soft: '4068'
          hard: '8192'
      '@mygroup':
        nproc:
          hard: '50'
      
This example creates the following entries in /etc/security/limits.conf:

    * nofile soft 2048
    * nofile hard 8192
    myuser nofile soft 4068
    myuser nofile hard 8192
    * nproc soft 20
    * nproc hard 20
    @mygroup nproc hard 50

replacing any existing items in the same domain.

You can also call it as a parameterised class passing in the configuration data as a hash - for example:

    class { 'limits':
      config => {
        '*' => {
          'nofile' => {
            soft => '2048',
            hard => '8192',
          },
          'nproc' => {
            soft => '20',
            hard => '20',
          },
        },
        '@mygroup' => {
          'nproc' => {
            hard => '50',
          }
        },
      },
      use_hiera => false,
    }

### Parameters

Each entry title is the domain name - for example '*' for all users, '@wheel'
for members of the wheel group, 'root' for the root user etc.

For each domain there is one or more items: one of: 'core', 'data', 'fsize',
'memlock', 'nofile', 'rss', 'stack', 'cpu', 'nproc', 'as', 'maxlogins',
'maxsyslogins', 'priority', 'locks', 'sigpending', 'msqqueue', 'nice',
'rtprio'. 

For each item the following parameters are accepted:

   * *soft*: the item's soft limit. Optional.

   * *hard*: the item's hard limit. Optional.

See the limits.conf(5) man page for more information.

Implementation based on https://projects.puppetlabs.com/projects/puppet/wiki/Puppet_Augeas

