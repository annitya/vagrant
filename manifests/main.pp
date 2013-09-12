stage { 'prepare': before => Stage['main'] }

class {
	'bootstrap':  stage => prepare;
	'tools':      stage => main;
	'php':        stage => main;
	'nginx':      stage => main;
	'nodejs':     stage => main;
	'mongodb':    stage => main;
}

addServer {'keymedia':
	site => 'keymedia.dev',
	root => '/vagrant/www/keymedia/keymedia/webroot'
}
addServer {'subkeymedia':
	site => '*.keymedia.dev',
	root => '/vagrant/www/keymedia/keymedia/webroot'
}
