package SyForm::Exception::Role::WithCreateArgs;

use Moose::Role;

has create_args => (
  is => 'ro',
  isa => 'ArrayRef',
  required => 1,
);

1;