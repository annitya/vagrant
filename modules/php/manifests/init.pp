class php::install {

    $phppackages = ['php5-cli', 'php5-sqlite', 'php5-intl', 'php5-curl', 'php5-common', 'php5-dev', 'php5-geoip', 'php5-gmp', 'php5-imagick', 'php5-imap', 'php5-mcrypt', 'php5-tidy', 'php-apc', 'php-pear', 'php5-xdebug', 'php5-gd', 'php5-mysql', 'php5-fpm', 'php5-xsl', 'php5-memcache', 'php5-memcached', 'libapache2-mod-php5']

    package { $phppackages: 
        ensure => installed
    }
    exec { 'pear-auto-discover':
        onlyif => 'test "`pear config-get auto_discover`" = "0"',
        command => 'pear config-set auto_discover 1 system',
    }
    exec { 'pear-update':
        command => 'pear update-channels && pear upgrade-all',
    }
}

class composer {
  $composer_command_name = 'composer'
  $composer_target_dir = '/usr/local/bin'
  $composer_user = 'root'
  
  exec { "wget-fetchcomposer":
    command     => "wget --output-document='${composer_target_dir}/${composer_command_name}' 'http://getcomposer.org/composer.phar'",
    unless		=> "test -s ${composer_target_dir}/${composer_command_name}"
  }

  exec { 'composer-fix-permissions':
    command => "chmod a+x ${composer_command_name}",
    cwd     => $composer_target_dir,
    user    => $composer_user,
    unless  => "test -x ${composer_target_dir}/${composer_command_name}",
    require => Exec['wget-fetchcomposer'],
  }

   exec { 'composer-update':
     command => "${composer_command_name} self-update",
     user    => $composer_user,
     require => Exec['composer-fix-permissions'],
   }
}

class php {
    include php::install
    include composer
}