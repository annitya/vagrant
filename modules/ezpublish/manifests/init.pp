class ezpublish {
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
        require => [ File['ezpublish-vhost'] ],
    }
}