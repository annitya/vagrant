class apache::install {

    package { 'apache2':
        ensure => installed
    }

    exec { 'upgrade-php':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'sudo apt-get install php5 -y',
        timeout => 1800,
        require => Package['apache2']
    }
}

class apache {
    include apache::install
}