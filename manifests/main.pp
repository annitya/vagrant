stage { 'prepare': before => Stage['main'] }

class {
    'bootstrap':    stage => prepare;
	'java':         stage => main;
	'mysql':        stage => main;
	'tools':        stage => main;
	'php':          stage => main;
}