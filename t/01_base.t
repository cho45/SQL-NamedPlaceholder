use Test::More;
use Test::Fatal;
use Test::Name::FromLine;

use SQL::NamedPlaceholder qw(bind_named);

subtest basic => sub {
	my ($sql, $bind) = bind_named(q{
		SELECT * FROM entry
			WHERE blog_id = :blog_id
			ORDER BY datetime DESC
			LIMIT :limit
	}, {
		blog_id => 3,
		limit   => 5
	});

	is $sql, q{
		SELECT * FROM entry
			WHERE blog_id = ?
			ORDER BY datetime DESC
			LIMIT ?
	};

	is_deeply $bind, [
		3,
		5
	];
};

subtest extend => sub {
	for my $op (qw/= <=> <> != <= < >= >/) {
		do {
			my ($sql, $bind) = bind_named(qq{
				SELECT * FROM entry
					WHERE blog_id $op ?
					ORDER BY datetime DESC
					LIMIT :limit
			}, {
				blog_id => 3,
				limit   => 5
			});

			is $sql, qq{
				SELECT * FROM entry
					WHERE blog_id $op ?
					ORDER BY datetime DESC
					LIMIT ?
			}, "foo $op ?";

			is_deeply $bind, [
				3,
				5
			], "foo $op ?";
		};

		do {
			my ($sql, $bind) = bind_named(qq{
				SELECT * FROM entry
					WHERE `blog_id` $op ?
					ORDER BY datetime DESC
					LIMIT :limit
			}, {
				blog_id => 3,
				limit   => 5
			});

			is $sql, qq{
				SELECT * FROM entry
					WHERE `blog_id` $op ?
					ORDER BY datetime DESC
					LIMIT ?
			}, "`foo` $op ?";

			is_deeply $bind, [
				3,
				5
			], "`foo` $op ?";
		};
	}
};


subtest array => sub {
	do {
		my ($sql, $bind) = bind_named(q{
			SELECT * FROM entry
				WHERE blog_id IN (:blog_id)
				ORDER BY datetime DESC
		}, {
			blog_id => [1, 2, 3],
		});

		is $sql, q{
			SELECT * FROM entry
				WHERE blog_id IN (?, ?, ?)
				ORDER BY datetime DESC
		};

		is_deeply $bind, [1, 2, 3];
	};

	do {
		my ($sql, $bind) = bind_named(q{
			SELECT * FROM entry
				WHERE blog_id IN (:blog_id)
				ORDER BY datetime DESC
		}, {
			blog_id => [undef],
		});

		is $sql, q{
			SELECT * FROM entry
				WHERE blog_id IN (?)
				ORDER BY datetime DESC
		};

		is_deeply $bind, [undef];
	};
};

subtest exceptions => sub {
	like exception { bind_named('', {}) }, qr/requires \$sql/;
	like exception { bind_named('SELECT * FROM entry', []) }, qr/must specify HASH/;
	like exception { bind_named('SELECT * FROM entry', undef) }, qr/must specify HASH/;
	is exception { bind_named('SELECT * FROM entry', bless(+{}, 'Foo')) }, undef;
};

done_testing;
