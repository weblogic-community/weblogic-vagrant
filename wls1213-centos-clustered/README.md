WebLogic 12.1.3 Clustered on CentOS
================================


This configuration creates a patched WebLogic 12c 12.1.3 Cluster (admin, node1, node2)

Getting started
---------------
This is what you need to download and install to get the environment stood up.

 * [VagrantUP (latest)](http://www.vagrantup.com)
 * [Oracle VirtualBox (latest)](http://www.virtualbox.org)
 * [Oracle JDK 7u55](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html) (a)
 * [Oracle WebLogic 11g 12.1.3](http://www.oracle.com/technetwork/middleware/downloads/index-087510.html) - download **wls1036_generic.jar**
 * [Git](https://help.github.com/articles/set-up-git) client

(a) Oracle JDK - make sure **puppet/manifests/site.pp** is pointing to the correct name of the JDK file you downloaded

Software
--------
 * CentOS 6.5 x86_64
 * Puppet 3.6.2 Future Parser
 * Oracle JDK 7 update 55
 * WebLogic 12c 12.1.3 (wls_121300.jar)

The used hiera files are at **puppet/hieradata**

Add all the Oracle binaris you download to /software, edit Vagrantfile and update
- admin.vm.synced_folder "/tmp/software", "/software"
- node1.vm.synced_folder "/tmp/software", "/software"
- node2.vm.synced_folder "/tmp/software", "/software"


Get up and running
------------------
To have your virtual machines up and running, issue the following commands:

# Admin Server
vagrant up admin

# Managed Server node1
vagrant up node1

# Managed Server node2
vagrant up node2

More information
================
Detailed vagrant steps (setup) can be found here:

http://vbatik.wordpress.com/2013/10/11/weblogic-12-1-2-00-with-vagrant/

The procedure has been and run tested on Mac.

