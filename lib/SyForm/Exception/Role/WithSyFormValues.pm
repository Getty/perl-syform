package SyForm::Exception::Role::WithSyFormValues;
# ABSTRACT: Role for exceptions with a SyForm::Values

use Moose::Role;

has values => (
  is => 'ro',
  does => 'SyForm::Values',
  required => 1,
  handles => [qw(
    syform
  )],
);

1;