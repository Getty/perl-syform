package SyForm::Exception::UnexpectedValueOnViewFieldRoles;

use Moose;
extends 'SyForm::Exception';

with qw(
  SyForm::Exception::Role::WithSyFormField
);

has error_ref => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);

sub throw_with_args {
  my ( $class, $field, $error_ref ) = @_;
  $class->throw('Unexpected value on viewfield_roles of field ('.
    $field->name.') view args with ref ('.$ref.').',
    field => $field,
    error_ref => $error_ref,
  );
};

1;