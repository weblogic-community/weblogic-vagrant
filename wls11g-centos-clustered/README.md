WebLogic 11g Clustered on CentOS
================================

The reference implementation of https://github.com/biemond/biemond-orawls optimized for Linux, Solaris and the use of Hiera. This Vagrant project creates a patched 12.1.2 WebLogic cluster with 3 nodes (adminsol, nodesol1, nodesol2). Make sure to review the [site.pp](https://github.com/weblogic-community/weblogic-vagrant/blob/master/wls11g-centos-clustered/puppet/manifests/site.pp) file. [Location of Hiera files](https://github.com/weblogic-community/weblogic-vagrant/blob/master/wls11g-centos-clustered/puppet/hieradata).

This configuration creates a patched WebLogic 11g 10.3.6 Cluster (admin, node1, node2)

Getting started
---------------
This is what you need to download and install to get the environment stood up.

 * [VagrantUP (latest)](http://www.vagrantup.com)
 * [Oracle VirtualBox (latest)](http://www.virtualbox.org)
 * [Oracle JDK 7u55](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html) (a)
 * [Oracle WebLogic 11g 10.3.6](http://www.oracle.com/technetwork/middleware/weblogic/downloads/wls-for-dev-1703574.html) - download **wls1036_generic.jar**
 * [Git](https://help.github.com/articles/set-up-git) client

(a) Oracle JDK - make sure **puppet/manifests/site.pp** is pointing to the correct name of the JDK file you downloaded

Software
--------
 * CentOS 6.5 x86_64
 * Puppet 3.6.2 Future Parser
 * Oracle JDK 7 update 55
 * WebLogic 11g 10.3.6 (wls1036_generic.jar)
 * WebLogic 11g 10.3.6 patch 17071663 (p17071663_1036_Generic.zip)

The used hiera files are at **puppet/hieradata**

Add all the Oracle binaris you download to /software, edit Vagrantfile and update
- admin.vm.synced_folder "/tmp/software", "/software"
- node1.vm.synced_folder "/tmp/software", "/software"
- node2.vm.synced_folder "/tmp/software", "/software"

Using the following facts
-------------------------
- environment => "development"
- vm_type     => "vagrant"

Also need to set "--parser future" (Puppet >= 3.40) to the puppet configuration, cause it uses lambda expressions for collection of yaml entries from application_One and application_Two

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
