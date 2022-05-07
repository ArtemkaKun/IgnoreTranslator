module main

import os
import flag

const (
	first_case_letter_shift  = 1
	second_case_letter_shift = 2
	case_construction_length = 4
)

const (
	gitignore_file_extension = '.gitignore'
)

fn main() {
	mut flag_parser := flag.new_flag_parser(os.args)
	set_up_flag_parser(mut flag_parser)

	path_to_gitignore := flag_parser.string('path', `p`, '', 'Path to a ,gitignore file that need to be converted').to_lower()
	handle_unprocessed_flags(mut flag_parser)

	valid, error_message := validate_path_to_gitignore_file(path_to_gitignore)

	if !valid {
		println(error_message)
		return
	}

	generate_ignore_conf_file(path_to_gitignore)
}

fn set_up_flag_parser(mut flag_parser flag.FlagParser) {
	flag_parser.application('IgnoreTranslator')
	flag_parser.version('0.0.1')
	flag_parser.description('Tool to translate .gitignore files to ignore.conf files')
	flag_parser.skip_executable()
}

fn handle_unprocessed_flags(mut flag_parser flag.FlagParser) {
	additional_args := flag_parser.finalize() or { []string{} }

	if additional_args.len > 0 {
		println('Unprocessed arguments:\n$additional_args.join_lines()')
	}
}

fn validate_path_to_gitignore_file(value string) (bool, string) {
	if value == '' {
		return false, 'Path to .gitignore file is not specified'
	} else if os.exists(value) == false {
		return false, 'File $value does not exist'
	} else if os.is_file(value) == false {
		return false, '$value is not a file'
	} else if os.is_readable(value) == false {
		return false, 'File $value is not readable'
	} else if value.ends_with(gitignore_file_extension) == false {
		return false, 'File $value is not a .gitignore file'
	}

	return true, ''
}

fn generate_ignore_conf_file(path_to_gitignore string) {
	path_to_ignore_conf := create_ignore_conf_file_path(path_to_gitignore)
	os.create(path_to_ignore_conf) or { panic(err) }

	gitignore_content := os.read_lines(path_to_gitignore) or { panic(err) }
	mut ignore_conf_content := []string{}

	for line in gitignore_content {
		ignore_conf_content << convert_gitignore_rule_to_ignore_conf_rule(line)
	}

	os.write_file(path_to_ignore_conf, ignore_conf_content.join_lines()) or { panic(err) }

	println('File $path_to_ignore_conf created')
}

fn create_ignore_conf_file_path(path_to_gitignore string) string {
	return path_to_gitignore.replace(gitignore_file_extension, 'ignore.conf')
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
