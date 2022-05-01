module main

import os

fn main() {}

pub fn create_ignore_conf_file(path_to_gitignore_file string) {
	os.create(path_to_gitignore_file.replace('.gitignore', 'ignore.conf')) or { panic(err) }
}
