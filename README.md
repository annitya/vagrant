Keymedia development environment
====
Vagrant with Puppet for a complete web development workspace

Content
=======
Ubuntu Server 12.04 + Nginx + PHP + MySQL + MongoDB + NodeJS + Redis and more... 

How
===
- VirtualBox must be installed and vagrant
- Make sure that you have the "precise32" box installed with that name. If not install it with command "vagrant box add precise32 http://files.vagrantup.com/precise32.box"

 1. Clone this repository
 2. Move into the repository and run "vagrant up" (This will take some minutes, you can continue to the next step while it's running)
 3. Add to your "hosts" file (OSX: /private/etc/hosts):
		47.47.47.47	keymedia.dev
		47.47.47.47	admin.keymedia.dev
		47.47.47.47	m.keymedia.dev
 4. Clone the keymedia repo into the "www" folder. (Move into the "www" folder and run "git clone https://github.com/KeyteqLabs/keymedia.git")
 5. When the "vagrant up" is finished you must log into your new VM with "vagrant ssh"
 6. Go to: cd /vagrant/www/keymedia
 	- Run composer "composer install"
 	- mkdir -p keymedia/resources/tmp/cache/templates
 6. An admin-user must be created in order to use the admin-panel
 		- Run the following command(Replace username and password as it suits you):
 			"/vagrant/www/keymedia/keymedia/run admin createUser --username=admin --password=su46fk39"
 7. You should now be able to head over to "http://admin.keymedia.dev" and login with the username/password you generated
 8. Create a new site with the following CNAME "m.keymedia.dev" and the cdn option turned off.
 9. You should be good to go!

 

    
