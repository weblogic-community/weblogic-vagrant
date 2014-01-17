WebLogic 12c Standalone on CentOS
=================================

The reference implementation of https://github.com/biemond/biemond-orawls optimized for Linux, Solaris and the use of Hiera. This Vagrant project creates a patched 12.1.2 WebLogic cluster with 3 nodes (adminsol, nodesol1, nodesol2). Make sure to review the [site.pp](https://github.com/weblogic-community/weblogic-vagrant/blob/master/wls12c-centos-standalone/puppet/manifests/site.pp) file. [Location of Hiera files](https://github.com/weblogic-community/weblogic-vagrant/blob/master/wls12c-centos-standalone/puppet/hieradata).

Getting started
---------------
This is what you need to download and install to get the environment stood up.

 * [Vagrant (latest)](http://www.vagrantup.com)
 * [Oracle VirtualBox (latest)](http://www.virtualbox.org)
 * [Oracle JDK 7u51](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html) (a)
 * [Oracle WebLogic 12c 12.1.2](http://www.oracle.com/technetwork/middleware/weblogic/downloads/wls-for-dev-1703574.html) - download **wls_121200.jar**
 * [Git](https://help.github.com/articles/set-up-git) client

(a) Oracle JDK - make sure **puppet/manifests/site.pp** is pointing to the correct name of the JDK file you downloaded

Next step
---------
Download Oracle JDK 7u51 and WebLogic 12.1.2 Generic and put them in the same folder as this README. The downloaded files must have the following names:
 * jdk-7u51-linux-x64.tar.gz
 * wls_121200.jar 

Software
--------
 * CentOS 6.5 x86_64
 * Puppet 3.4.2 Future Parser
 * Oracle JDK 7 update 51
 * WebLogic 12c 12.1.2

Get up and running
------------------
To have your virtual machines up and running, issue the following commands:

### Admin Server  
<pre>$ vagrant up adminsol</pre>

Detailed steps at original blog post
------------------------------------
http://vbatik.wordpress.com/2013/10/11/weblogic-12-1-2-00-with-vagrant/

The procedure has been and run tested on Mac.

<pre>Based on work by Matthew Baldwin</pre>
