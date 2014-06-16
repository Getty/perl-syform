package SyForm::Exception::Role::WithSyFormValues;
# ABSTRACT: Role for exceptions with a SyForm::Values

use Moo::Role;

has values => (
  is => 'ro',
  required => 1,
  handles => [qw(
    syform
  )],
);

1;