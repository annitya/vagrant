class mysql::install {
    package { 'mysql-server':
        ensure => installed
    }
}

class mysql:createDb {
        exec { 'create-forlagsh-db':
          unless => "/usr/bin/mysql -uvagrant -pvagrant forlagsh",
          command => "/usr/bin/mysql -uroot -e \"create database forlagsh character set utf8;",
          require => Service["mysqld"],
        }
}

class mysql:createUser {
    exec { 'create-forlagsh-user':
        unless => "/usr/bin/mysql -uforlagsh -pforlagsh",
        command => "grant all on forlagsh.* to forlagsh@localhost identified by 'forlagsh';\",
        require => Class['mysql:createDb']
}

class mysql::run {
    service { mysql:
        enable => true,
        ensure => running,
        hasstatus => true,
        hasrestart => true,
        subscribe => Package['mysql-server'],
        require => Class['mysql::createDb', 'mysql::createUser']
    }
}

class mysql {
    include mysql::createDb
    include mysql::createUser
    include mysql::run
}