use Test::More;
use Test::Name::FromLine;

use SQL::NamedPlaceholder qw(bind_named);

do {
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


done_testing;
