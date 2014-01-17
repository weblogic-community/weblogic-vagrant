WebLogic 12c Clustered on Solaris
=================================

The reference implementation of https://github.com/biemond/biemond-orawls optimized for Linux, Solaris and the use of Hiera. This Vagrant project creates a patched 12.1.2 WebLogic cluster with 3 nodes (adminsol, nodesol1, nodesol2). Make sure to review the [site.pp](https://github.com/weblogic-community/weblogic-vagrant/blob/master/wls12c-solaris-clustered/puppet/manifests/site.pp) file. [Location of Hiera files](https://github.com/weblogic-community/weblogic-vagrant/blob/master/wls12c-solaris-clustered/puppet/hieradata).

Getting started
---------------
This is what you need to download and install to get the environment stood up.

 * [VagrantUP (latest)](http://www.vagrantup.com)
 * [Oracle VirtualBox (latest)](http://www.virtualbox.org)
 * [Oracle JDK 7u51](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html) (a)
 * [Oracle WebLogic 12c 12.1.2](http://www.oracle.com/technetwork/middleware/weblogic/downloads/wls-for-dev-1703574.html) - download **wls_121200.jar**
 * [Git](https://help.github.com/articles/set-up-git) client

(a) Oracle JDK - make sure **puppet/manifests/site.pp** is pointing to the correct name of the JDK file you downloaded

Software
--------
 * Solaris 10 x86_64
 * Oracle JDK 7 update 51
 * WebLogic 12c 12.1.2 (wls_121200.jar or fmw_infra_121200.jar)
 * WebLogic 12c 12.1.2 patch 16175470 (p16175470_121200_Generic.zip)

Using the following facts
-------------------------
 * environment => "development"
 * vm_type     => "vagrant"
 * env_app1    => "application_One"
 * env_app2    => "application_Two"

Also need to set "--parser future" to the puppet configuration, cause it uses lambda expressions for collection of yaml entries from application_One and application_Two

Get up and running
------------------
To have your virtual machines up and running, issue the following commands:

### Admin Server  
<pre>$ vagrant up adminsol</pre>

### Managed Server node1  
<pre>$ vagrant up nodesol1</pre>

### Managed Server node2  
<pre>$ vagrant up nodesol2</pre>

