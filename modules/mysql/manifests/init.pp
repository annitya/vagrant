class mysql::install {
    package { 'mysql-server':
        ensure => installed
    }
}

class mysql::createDb {
    exec { 'create-forlagsh-db':
        unless => "/usr/bin/mysql -root forlagsh",
        command => "/usr/bin/mysql -uroot -e \"create database forlagsh character set utf8;\"",
        require => Package['mysql-server']
    }
}


class mysql::createUser {
    exec { 'create-forlagsh-user':
        unless => "/usr/bin/mysql -uforlagsh -pforlagsh",
        command => "/usr/bin/mysql -uroot -e \"grant all on forlagsh.* to forlagsh@localhost identified by 'forlagsh';\"",
        require => Class['mysql::createDb']
    }
}

class mysql::run {
    service { mysql:
        enable => true,
        ensure => running,
        hasstatus => true,
        hasrestart => true,
        require => Package['mysql-server']
    }
}

class mysql {
    include mysql::install
    include mysql::createDb
    include mysql::createUser
    include mysql::run
}