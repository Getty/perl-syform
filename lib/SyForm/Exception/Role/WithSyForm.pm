package SyForm::Exception::Role::WithSyForm;

use Moose::Role;

has syform => (
  is => 'ro',
  does => 'SyForm',
  required => 1,
);

1;