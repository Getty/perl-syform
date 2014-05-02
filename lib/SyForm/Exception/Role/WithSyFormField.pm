package SyForm::Exception::Role::WithSyFormField;

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