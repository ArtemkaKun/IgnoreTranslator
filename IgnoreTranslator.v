module main

import os

const (
	first_case_letter_shift  = 1
	second_case_letter_shift = 2
	case_construction_length = 4
)

fn main() {}

fn create_ignore_conf_file(path_to_gitignore_file string) {
	os.create(path_to_gitignore_file.replace('.gitignore', 'ignore.conf')) or { panic(err) }
}

fn convert_gitignore_rule_to_ignore_conf_rule(gitignore_rule string) string {
	return get_converted_rule(gitignore_rule)
}

fn get_converted_rule(rule string) string {
	success, result := try_convert_rule_with_cases(rule)

	if success == true {
		return result
	}

	return rule
}

fn try_convert_rule_with_cases(gitignore_rule string) (bool, string) {
	for char_index, letter in gitignore_rule {
		if letter.ascii_str() == '[' {
			return true, generate_case_variants_of_rule(gitignore_rule, char_index)
		}
	}

	return false, ''
}

fn generate_case_variants_of_rule(gitignore_rule string, char_index int) string {
	mut case_rules_variants := []string{}

	first_case_variant := generate_case(char_index, first_case_letter_shift, gitignore_rule)
	case_rules_variants << get_converted_rule(first_case_variant)

	second_case_variant := generate_case(char_index, second_case_letter_shift, gitignore_rule)
	case_rules_variants << get_converted_rule(second_case_variant)

	return case_rules_variants.join('\n')
}

fn generate_case(original_char_index int, case_char_shift int, gitignore_rule string) string {
	case_letter := gitignore_rule[original_char_index + case_char_shift].ascii_str()

	mut case_variant := ''

	for char_counter in 0 .. original_char_index {
		case_variant += gitignore_rule[char_counter].ascii_str()
	}

	case_variant += case_letter

	for char_counter in original_char_index + case_construction_length .. gitignore_rule.len {
		case_variant += gitignore_rule[char_counter].ascii_str()
	}

	return case_variant
}
