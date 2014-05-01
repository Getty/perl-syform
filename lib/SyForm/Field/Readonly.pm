package SyForm::Field::Readonly;
# ABSTRACT: Readonly fields

use Moose::Role;

with qw(
  SyForm::Field::Default
);

has readonly => (
  is => 'ro',
  isa => 'Bool',
  default => sub { 1 },
);

1;
