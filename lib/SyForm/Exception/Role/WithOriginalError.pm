package SyForm::Exception::Role::WithOriginalError;

use Moose::Role;

has original_error => (
  is => 'ro',
  required => 1,
);

1;