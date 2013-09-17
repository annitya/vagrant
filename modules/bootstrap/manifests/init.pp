class bootstrap {

    package { 'python-software-properties':
        ensure => installed
    }

    exec { 'add-php5-repository':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'sudo add-apt-repository ppa:ondrej/php5'
    }

    exec { 'apt-get-update':
        command => 'sudo apt-get update'
    }

    group { "puppet": 
    	ensure => "present", 
  	}
}
