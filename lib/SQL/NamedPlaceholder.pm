package SQL::NamedPlaceholder;

use strict;
use warnings;
use Exporter::Lite;

our $VERSION = '0.01';
our @EXPORT_OK = qw(bind_named);

sub bind_named {
	my ($sql, $hash) = @_;

	my $bind = [];

	$sql =~ s{:(\w+)}{
		my $type = ref($hash->{$1});
		if ($type eq 'ARRAY') {
			if (@{ $hash->{$1} }) {
				push @$bind, @{ $hash->{$1} };
				join ', ', map { '?' } @{ $hash->{$1} };
			} else {
				push @$bind, undef;
				'?';
			}
		} else {
			push @$bind, $hash->{$1};
			'?';
		}
	}eg;

	($sql, $bind);
}

1;
__END__

=encoding utf8

=head1 NAME

SQL::NamedPlaceholder - 

=head1 SYNOPSIS

  use SQL::NamedPlaceholder qw(bind_named);

  my ($sql, $bind) = bind_named(q[
      SELECT *
      FROM entry
      WHERE
          user_id = :user_id
  ], {
      user_id = $user_id
  });

  $dbh->prepare_cached($sql)->execute(@$bind);


=head1 DESCRIPTION

SQL::NamedPlaceholder is 

=head1 AUTHOR

cho45 E<lt>cho45@lowreal.netE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
