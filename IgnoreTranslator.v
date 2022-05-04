module main

import os

fn main() {}

fn create_ignore_conf_file(path_to_gitignore_file string) {
	os.create(path_to_gitignore_file.replace('.gitignore', 'ignore.conf')) or { panic(err) }
}

fn convert_gitignore_rule_to_ignore_conf_rule(gitignore_rule string) string {
	for char_index, letter in gitignore_rule {
		if letter.ascii_str() == '[' {
			mut case_rules_variants := []string{}
			first_case := gitignore_rule[char_index + 1].ascii_str()

			mut first_case_variant := ''

			for char_counter in 0 .. char_index {
				first_case_variant += gitignore_rule[char_counter].ascii_str()
			}

			first_case_variant += first_case

			for char_counter in char_index + 4 .. gitignore_rule.len {
				first_case_variant += gitignore_rule[char_counter].ascii_str()
			}

			case_rules_variants << first_case_variant

			second_case := gitignore_rule[char_index + 2].ascii_str()

			mut second_case_variant := ''

			for char_counter in 0 .. char_index {
				second_case_variant += gitignore_rule[char_counter].ascii_str()
			}

			second_case_variant += second_case

			for char_counter in char_index + 4 .. gitignore_rule.len {
				second_case_variant += gitignore_rule[char_counter].ascii_str()
			}

			case_rules_variants << second_case_variant

			return '${case_rules_variants[0]}\n${case_rules_variants[1]}'
		}
	}

	return gitignore_rule
}
