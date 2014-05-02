package SyForm::Exception::UnexpectedCallToGetValueByArgs;

use Moose;
extends 'SyForm::Exception';

with qw(
  SyForm::Exception::Role::WithSyFormField
);

sub throw_with_args {
  my ( $class, $field ) = @_;
  $class->throw('Unexpected call to get_value_by_args on the field ('.
    $field->name.'). There must be a call to has_value_by_args before using this function, to assure there exist a value.',
    field => $field,
  );
};

1;