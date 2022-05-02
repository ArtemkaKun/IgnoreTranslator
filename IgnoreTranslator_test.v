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

fn test_convert_gitignore_rule_to_ignore_conf_rule() {
	rules := ['Library', '/Library', 'Library/', '/Library/', '[Ll]ibrary', '/[Ll]ibrary',
		'[Ll]ibrary/', '/[Ll]ibrary/']
	expected_results := ['Library', '/Library', 'Library/', '/Library/', 'Library\nlibrary',
		'/Library\n/library', 'Library/\nlibrary/', '/Library/\n/library/']
	mut actual_results := []string{}

	for rule in rules {
		actual_results << convert_gitignore_rule_to_ignore_conf_rule(rule)
	}

	assert actual_results == expected_results
}
