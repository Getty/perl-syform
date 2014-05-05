package SyForm::Exception::Role::WithSyFormField;
# ABSTRACT: Role for exceptions with a SyForm field as reference

use Moose::Role;

has field => (
  is => 'ro',
  does => 'SyForm::Field',
  required => 1,
  handles => [qw(
    syform
  )],
);

1;