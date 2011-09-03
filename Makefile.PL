BEGIN {
	my @mip = qw(
		Module::Install::AuthorTests
		Module::Install::Repository
		Module::Install::ReadmeFromPod
		Module::Install::TestBase
	);
	for (@mip) {
		eval "require $_";
		if ($@) {
			eval "require inc::$_";
			if ($@) {
				warn $@;
				printf("# Install following (perl Makefile.PL | cpanm):\n%s", join("\n", @mip));
				exit 1;
			}
		}
	}
};

use inc::Module::Install;
name 'SQL-NamedPlaceholder';
all_from 'lib/SQL/NamedPlaceholder.pm';

requires 'Exporter::Lite';
requires 'Scalar::Util';
requires 'Carp';

build_requires 'Test::Name::FromLine';

# Module::Install::AuthorTests
author_tests('xt');

# Module::Install::Repository
auto_set_repository;

# Module::Install::ReadmeFromPod
readme_from 'lib/SQL/NamedPlaceholder.pm';

auto_include;
WriteAll;
