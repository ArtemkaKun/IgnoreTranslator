module main

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

fn test_convert_complexs_gitignore_rule_to_ignore_conf_rule() {
	rule := '/[Aa]ssets/[Aa]ddressable[Aa]ssets[Dd]ata/*/*.bin*'
	expected_result := '/Assets/AddressableAssetsData/*/*.bin*\n/Assets/AddressableAssetsdata/*/*.bin*\n/Assets/AddressableassetsData/*/*.bin*\n/Assets/Addressableassetsdata/*/*.bin*\n/Assets/addressableAssetsData/*/*.bin*\n/Assets/addressableAssetsdata/*/*.bin*\n/Assets/addressableassetsData/*/*.bin*\n/Assets/addressableassetsdata/*/*.bin*\n/assets/AddressableAssetsData/*/*.bin*\n/assets/AddressableAssetsdata/*/*.bin*\n/assets/AddressableassetsData/*/*.bin*\n/assets/Addressableassetsdata/*/*.bin*\n/assets/addressableAssetsData/*/*.bin*\n/assets/addressableAssetsdata/*/*.bin*\n/assets/addressableassetsData/*/*.bin*\n/assets/addressableassetsdata/*/*.bin*'

	actual_result := convert_gitignore_rule_to_ignore_conf_rule(rule)

	splited_actual_result := actual_result.split('\n')
	splited_expected_result := expected_result.split('\n')

	for result in splited_actual_result {
		assert result in splited_expected_result
	}
}

fn test_convert_gitignore_exception_rule_to_ignore_conf_rule() {
	rules := ['!Library', '!/Library', '!Library/', '!/Library/', '![Ll]ibrary', '!/[Ll]ibrary',
		'![Ll]ibrary/', '!/[Ll]ibrary/']
	expected_results := ['!Library', '!/Library', '!Library/', '!/Library/', '!Library\n!library',
		'!/Library\n!/library', '!Library/\n!library/', '!/Library/\n!/library/']
	mut actual_results := []string{}

	for rule in rules {
		actual_results << convert_gitignore_rule_to_ignore_conf_rule(rule)
	}

	assert actual_results == expected_results
}

fn test_convert_gitignore_comment_rule_to_ignore_conf_rule() {
	rules := ['#Library', '#/Library', '#Library/', '#/Library/', '#[Ll]ibrary', '#/[Ll]ibrary',
		'#[Ll]ibrary/', '#/[Ll]ibrary/']
	expected_results := ['#Library', '#/Library', '#Library/', '#/Library/', '#Library\n#library',
		'#/Library\n#/library', '#Library/\n#library/', '#/Library/\n#/library/']
	mut actual_results := []string{}

	for rule in rules {
		actual_results << convert_gitignore_rule_to_ignore_conf_rule(rule)
	}

	assert actual_results == expected_results
}
