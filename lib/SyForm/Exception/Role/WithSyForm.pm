package SyForm::Exception::Role::WithSyForm;
# ABSTRACT: Role for exceptions with a SyForm instance as reference

use Moose::Role;

has syform => (
  is => 'ro',
  does => 'SyForm',
  required => 1,
);

1;