package SyForm::Exception::Role::WithCreateArgs;
# ABSTRACT: Role for exceptions around the create process

use Moose::Role;

has create_args => (
  is => 'ro',
  isa => 'ArrayRef',
  required => 1,
);

1;