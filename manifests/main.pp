Exec {
    path => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin']
}

stage { 'prepare':
    before => Stage['main']
}

stage { 'configure':
    require => Stage['main']
}

class {
    'bootstrap':    stage => prepare;
	'java':         stage => main;
	'mysql':        stage => main;
	'tools':        stage => main;
	'php':          stage => main;
	'apache':       stage => main;
    'ezpublish':    stage => configure;
}