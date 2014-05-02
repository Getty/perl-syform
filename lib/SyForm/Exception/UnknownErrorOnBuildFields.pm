package SyForm::Exception::UnknownErrorOnBuildFields;

use Moose;
extends 'SyForm::Exception';

with qw(
  SyForm::Exception::Role::WithSyForm
  SyForm::Exception::Role::WithOriginalError
);

sub throw_with_args {
  my ( $class, $syform, $error ) = @_;
  $class->rethrow_syform_exception($error);
  $class->throw($class->error_message_text($error).' on building up of fields',
    syform => $syform,
    original_error => $error,
  );
};

1;