class bootstrap {

    $updateCommand = 'sudo apt-get update'

    exec { 'apt-initial-update':
        command => $updateCommand
    }

    package { 'python-software-properties':
        ensure => installed,
        require => Exec['apt-initial-update']
    }

    exec { 'add-php5-repository':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'sudo add-apt-repository ppa:ondrej/php5',
        require => Package['python-software-properties']
    }

    exec { 'apt-get-update':
        command => $updateCommand,
        require => Exec['add-php5-repository']
    }

    group { "puppet": 
        ensure => "present",
    }
}
