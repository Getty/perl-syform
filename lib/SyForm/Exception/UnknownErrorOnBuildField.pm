package SyForm::Exception::UnknownErrorOnBuildField;
# ABSTRACT: Exception at the building of one specific field on a SyForm

use Moose;
extends 'SyForm::Exception';

with qw(
  SyForm::Exception::Role::WithOriginalError
);

has field_name => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);

has field_args => (
  is => 'ro',
  isa => 'HashRef',
  required => 1,
);

sub throw_with_args {
  my ( $class, $field_name, $field_args, $error ) = @_;
  $class->rethrow_syform_exception($error);
  SyForm->throw( ValidationFailedForTypeConstraint =>
    $field_name, $field_args, $error
  ) if $error->isa('Moose::Exception::ValidationFailedForTypeConstraint');
  $class->throw($class->error_message_text($error).' on building up of field ('.$field_name.')',
    field_args => $field_args,
    field_name => $field_name,
    original_error => $error,
  );
};

1;