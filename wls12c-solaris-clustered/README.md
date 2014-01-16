WebLogic 12c Cluster on Solaris
==============================

The reference implementation of https://github.com/biemond/biemond-orawls optimized for Linux, Solaris and the use of Hiera. This Vagrant project creates a patched 12.1.2 WebLogic cluster with 3 nodes (adminsol, nodesol1, nodesol2). If you want, check the [site.pp](https://github.com/weblogic-community/weblogic-vagrant/blob/master/wls12c-solaris-clustered/puppet/manifests/site.pp) file.

[Location of Hiera files](https://github.com/weblogic-community/weblogic-vagrant/blob/master/wls12c-solaris-clustered/puppet/hieradata).

Software
--------
 * Oracle JDK 7 update 45
 * WebLogic 12c 12.1.2 (wls_121200.jar or fmw_infra_121200.jar)
 * WebLogic 12c 12.1.2 patch 16175470 (p16175470_121200_Generic.zip)

Using the following facts
-------------------------

 * environment => "development"
 * vm_type     => "vagrant"
 * env_app1    => "application_One"
 * env_app2    => "application_Two"

Also need to set "--parser future" to the puppet configuration, cause it uses lambda expressions for collection of yaml entries from application_One and application_Two

### Admin Server  
<pre>$ vagrant up adminsol</pre>

### Node Manager node1  
<pre>$ vagrant up nodesol1</pre>

### Node Manager node2  
<pre>$ vagrant up nodesol2</pre>
