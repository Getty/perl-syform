package SyForm::Field::Readonly;
# ABSTRACT: TODO

die "TODO";

use Moose::Role;
use namespace::autoclean;

has readonly => (
  is => 'ro',
  isa => 'Bool',
  required => 1,
);

1;
