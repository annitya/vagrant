Exec {
    path => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin']
}

stage { 'prepare': before => Stage['main'] }

class {
    'bootstrap':    stage => prepare;
	'java':         stage => main;
	'mysql':        stage => main;
	'tools':        stage => main;
	'php':          stage => main;
	'ezpublish':    stage => main;
	'apache':       stage => main;
}