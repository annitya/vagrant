class apache::install {

    package { 'apache2':
        ensure => installed
    }

    package { 'php5-common':
        ensure => installed
    }

    package { 'libapache2-mod-php5':
        ensure => installed
    }

    exec { 'upgrade-php':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'sudo apt-get install php5 -y',
        timeout => 1800,
        require => Package['apache2, php5-common, libapache2-mod-php5']
    }
}

class apache::configure {
    file { 'httpd-configuration':
        ensure  => present,
        path    => '/etc/apache2/conf-enabled/httpd.conf',
        owner   => 'root',
        group   => 'root',
        content => template('apache/httpd.conf.erb'),
    }

    file { 'envvars-configuration':
        ensure  => present,
        path    => '/etc/apache2/envvars',
        owner   => 'root',
        group   => 'root',
        content => template('apache/envvars.erb'),
    }

    exec { 'apache-rewrite-mod':
        command => 'sudo a2enmod rewrite'
    }
}

class apache::restart {
    exec { 'restart-apache':
        command => 'sudo apachectl restart'
    }
}

class apache {
    include apache::install
    include apache::configure
    include apache::restart
}