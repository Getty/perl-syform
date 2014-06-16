package SyForm::Exception::Role::WithSyFormField;
# ABSTRACT: Role for exceptions with a SyForm field as reference

use Moo::Role;

has field => (
  is => 'ro',
  required => 1,
  handles => [qw(
    syform
  )],
);

1;