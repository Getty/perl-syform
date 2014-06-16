package SyForm::Exception::Role::WithSyForm;
# ABSTRACT: Role for exceptions with a SyForm instance as reference

use Moo::Role;

has syform => (
  is => 'ro',
  required => 1,
);

1;