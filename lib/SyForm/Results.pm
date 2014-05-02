package SyForm::Results;

use Moose::Role;
use namespace::autoclean;

with qw(
  SyForm::Fields
);

# TODO
# use MooseX::Role::WithOverloading;
# use overload q{%{}} => 'as_hashref';

has values => (
  is => 'ro',
  isa => 'SyForm::Values',
  required => 1,
  handles => [qw(
    syform
    field
  )],
);

1;