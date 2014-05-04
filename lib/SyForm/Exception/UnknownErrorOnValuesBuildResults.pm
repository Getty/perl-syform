package SyForm::Exception::UnknownErrorOnValuesBuildResults;

use Moose;
extends 'SyForm::Exception';

with qw(
  SyForm::Exception::Role::WithSyFormValues
  SyForm::Exception::Role::WithOriginalError
);

sub throw_with_args {
  my ( $class, $values, $original_error ) = @_;
  $class->rethrow_syform_exception($original_error);
  $class->throw($class->error_message_text($original_error).' on build of results',
    values => $values,
    original_error => $original_error,
  );
};

1;