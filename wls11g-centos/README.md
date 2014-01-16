biemond-orawls-vagrant
=======================

The reference implementation of https://github.com/biemond/biemond-orawls  
optimized for linux and the use of Hiera  

uses CentOS 6.5 box with puppet 3.4.2 Future Parser

creates a patched 10.3.6 WebLogic cluster ( admin,node1 , node2 )


site.pp is located here:  
https://github.com/biemond/biemond-orawls-vagrant/blob/master/puppet/manifests/site.pp  

The used hiera files https://github.com/biemond/biemond-orawls-vagrant/tree/master/puppet/hieradata

Add the all the Oracle binaris to /software, edit Vagrantfile and update
- admin.vm.synced_folder "/Users/edwin/software", "/software"
- node1.vm.synced_folder "/Users/edwin/software", "/software"
- node2.vm.synced_folder "/Users/edwin/software", "/software"


used the following software
- jdk-7u45-linux-x64.tar.gz

weblogic 10.3.6
- wls1036_generic.jar
- p17071663_1036_Generic.zip ( 10.3.6.06 BSU Patch)

Using the following facts

- environment => "development"
- vm_type     => "vagrant"

also need to set "--parser future" (Puppet >= 3.40) to the puppet configuration, cause it uses lambda expressions for collection of yaml entries from application_One and application_Two


# admin server  
vagrant up admin

# node1  
vagrant up node1

# node2  
vagrant up node2


Detailed vagrant steps (setup) can be found here:

http://vbatik.wordpress.com/2013/10/11/weblogic-12-1-2-00-with-vagrant/

For Mac Users.  The procedure has been and run tested on Mac.
