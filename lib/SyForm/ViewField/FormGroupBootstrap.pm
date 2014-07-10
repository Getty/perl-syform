package SyForm::ViewField::FormGroupBootstrap;
# ABSTRACT: Form group in a Bootstrap form

use Moo;

with qw(
  MooX::Traits
);

our @attributes = qw(
  help
);

for my $attribute (@attributes) {
  has $attribute => (
    is => 'ro',
    predicate => 1,
  );
}

1;
