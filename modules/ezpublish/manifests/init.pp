class ezpublish::configure_apache {

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
}

class ezpublish::configure_php {

    file { 'php-configuration':
        ensure  => present,
        path    => '/etc/php5/apache2/php.ini',
        owner   => 'root',
        group   => 'root',
        content => template('php/php.ini.erb'),
    }

    file { 'xdebug-configuration':
        ensure  => present,
        path    => '/etc/php5/apache2/conf.d/20-xdebug.ini',
        owner   => 'root',
        group   => 'root',
        content => template('php/xdebug.ini.erb'),
    }

    file { '/etc/php5/cli/php.ini':
        ensure => link,
        target => '/etc/php5/apache2/php.ini'
    }
}

class ezpublish::configure_vhost {

    file { 'ezpublish-vhost':
        ensure  => present,
        path    => '/etc/apache2/sites-available/ezpublish.conf',
        owner   => 'root',
        group   => 'root',
        content => template('ezpublish/vhost.conf.erb'),
    }

    file { 'ezpublish-vhost-enable':
        ensure  => link,
        path    => '/etc/apache2/sites-enabled/ezpublish.conf',
        target  => '/etc/apache2/sites-available/ezpublish.conf',
        require => [ File['ezpublish-vhost'] ]
    }
}

class ezpublish::post_configure {

    exec { 'apache-rewrite-mod':
        command => 'sudo a2enmod rewrite'
    }

    exec { 'restart-apache':
        command => 'sudo apachectl restart',
        require => Class['ezpublish::configure_apache', 'ezpublish::configure_php', 'ezpublish::configure_vhost']
    }
}

class ezpublish {
    include ezpublish::configure_apache
    include ezpublish::configure_php
    include ezpublish::configure_vhost
    include ezpublish::post_configure
}