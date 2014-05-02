package SyForm::Values;

use Moose::Role;
use namespace::autoclean;

with qw(
  SyForm::Fields
);

has syform => (
  is => 'ro',
  isa => 'SyForm',
  required => 1,
  handles => [qw(
    field
  )],
);

1;