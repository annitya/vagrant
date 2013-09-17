Haugenbok development environment
====
Vagrant with Puppet for a complete web development workspace

Content
=======
Ubuntu Server 12.04 + Apache + PHP 5.5 w/xDebug 2.2.3 + MySQL

How
===
    * Install Vagrant and virtualbox.
    * Clone this repository.


Use existing environment
========================
    * Remove the www-folder
    * Create a symlink to your existing environment.


Start from scratch
==================
    * Checkout the customer repository.
    * Copy all legacy-stuff to ezpublish_legacy.
    * Run composer install and update.
    * Grab a fresh sql-dump and import it into your favorite mysql-installation. (The virtual-machine also has an empty database ready for you!)
    * If you want images and have a lot of time to spare: grab a copy of the sitefiles as well.


And then
========
    * Virtualbox doesn't deal well with absolute symbolic links.
    * Standing in the www-folder, run the folllowing command: ../tools/symlinks -cr *
    * This will convert all symbolic links to relative ones.


You should determine which sql-server you wish to use and update the ezpublish-configuration accordingly.
Type "vagrant up" and grab a cup of coffee.
Start solr and do a complete reindex.


Facts
======
    * The ip-address of the virtual-machine is 33.33.33.10
    * You can access it by typing "vagrant ssh"
    * Vagrant suspend will save the current state
    * Vagrant halt will shut down virtual-machine gracefully
    * Mysql stuff: root/no password, forlagsh/forlagsh, database: haugenbok.

 

    
