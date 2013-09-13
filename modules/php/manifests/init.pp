class php::install {
    $phppackages = ['php5-cli', 'php5-sqlite', 'php5-intl', 'php5-curl', 'php5-common', 'php5-dev', 'php5-geoip', 'php5-gmp', 'php5-imagick', 'php5-imap', 'php5-mcrypt', 'php5-tidy', 'php-apc', 'php-pear', 'php5-xdebug', 'php5-gd', 'php5-mysql', 'php5-fpm', 'php5-xsl']
    
    package { $phppackages: 
        ensure => installed
    }
    exec { 'pear-auto-discover':
        path => '/usr/bin:/usr/sbin:/bin',
        onlyif => 'test "`pear config-get auto_discover`" = "0"',
        command => 'pear config-set auto_discover 1 system',
    }
    exec { 'pear-update':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'pear update-channels && pear upgrade-all',
    }
    exec { 'install-phpunit':
        unless => "/usr/bin/which phpunit",
        command => '/usr/bin/pear install pear.phpunit.de/PHPUnit --alldeps',
        require => [Exec['pear-auto-discover'], Exec['pear-update']]
    }
    exec { 'install-phpqatools':
        unless => "/usr/bin/which phpcs",
        command => "/usr/bin/pear install pear.phpqatools.org/phpqatools --alldeps",
        require => [Exec['pear-auto-discover'], Exec['pear-update']]
    }
    exec { 'install-phpdocumentor':
        unless => "/usr/bin/which phpdoc",
        command => "/usr/bin/pear install pear.phpdoc.org/phpDocumentor-alpha --alldeps",
        require => [Exec['pear-auto-discover'], Exec['pear-update']]
    }
    
}

class php::configure {
    exec { 'php-cli-set-timezone':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'sed -i \'s/^[; ]*date.timezone =.*/date.timezone = Europe\/Madrid/g\' /etc/php5/cli/php.ini',
        onlyif => 'test "`php -c /etc/php5/cli/php.ini -r \"echo ini_get(\'date.timezone\');\"`" = ""',
        require => Class['php::install']
    }
    exec { 'php-cli-disable-short-open-tag':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'sed -i \'s/^[; ]*short_open_tag =.*/short_open_tag = Off/g\' /etc/php5/cli/php.ini',
        onlyif => 'test "`php -c /etc/php5/cli/php.ini -r \"echo ini_get(\'short_open_tag\');\"`" = "1"',
        require => Class['php::install']
    }
    exec { 'php-fpm-set-timezone':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'sed -i \'s/^[; ]*date.timezone =.*/date.timezone = Europe\/Madrid/g\' /etc/php5/fpm/php.ini',
        onlyif => 'test "`php -c /etc/php5/fpm/php.ini -r \"echo ini_get(\'date.timezone\');\"`" = ""',
        require => Class['php::install'],
        notify => Service['php5-fpm']
    }
    exec { 'php-fpm-disable-short-open-tag':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'sed -i \'s/^[; ]*short_open_tag =.*/short_open_tag = Off/g\' /etc/php5/fpm/php.ini',
        onlyif => 'test "`php -c /etc/php5/fpm/php.ini -r \"echo ini_get(\'short_open_tag\');\"`" = "1"',
        require => Class['php::install'],
        notify => Service['php5-fpm']
    }
}

class php::run {
    service { php5-fpm:
        enable => true,
        ensure => running,
        hasstatus => true,
        hasrestart => true,
        require => Class['php::install', 'php::configure'],
    }
}

class composer {
  $composer_command_name = 'composer'
  $composer_target_dir = '/usr/local/bin'
  $composer_user = 'root'
  
  exec { "wget-fetchcomposer":
    command     => "wget --output-document='${composer_target_dir}/${composer_command_name}' 'http://getcomposer.org/composer.phar'",
    path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin',
    unless		=> "test -s ${composer_target_dir}/${composer_command_name}"
  }

  exec { 'composer-fix-permissions':
    command => "chmod a+x ${composer_command_name}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => $composer_target_dir,
    user    => $composer_user,
    unless  => "test -x ${composer_target_dir}/${composer_command_name}",
    require => Exec['wget-fetchcomposer'],
  }

   exec { 'composer-update':
     command => "${composer_command_name} self-update",
     path    => "/usr/bin:/bin:/usr/sbin:/sbin:${composer_target_dir}",
     user    => $composer_user,
     require => Exec['composer-fix-permissions'],
   }
}

class php {
    include php::install
    include composer
    include php::configure
    include php::run
}