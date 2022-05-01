module main

import os

fn test_create_ignore_conf_file_next_to_gitignore_file() {
	os.mkdir('Test') or { panic(err) }
	os.create('Test/.gitignore') or { panic(err) }
	create_ignore_conf_file('Test/.gitignore')
	ignore_file_exists := os.exists('Test/ignore.conf')

	os.rmdir_all('Test') or { panic(err) }

	assert ignore_file_exists == true
}
