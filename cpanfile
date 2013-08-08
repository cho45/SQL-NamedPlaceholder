requires 'Carp';
requires 'Exporter::Lite';
requires 'Scalar::Util';

on build => sub {
    requires 'ExtUtils::MakeMaker', '6.36';
    requires 'Test::Name::FromLine';
};
