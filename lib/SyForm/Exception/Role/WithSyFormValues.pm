package SyForm::Exception::Role::WithSyFormValues;

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