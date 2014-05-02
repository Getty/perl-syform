package SyForm::Exception::UnknownErrorOnCreate;

use Moose;
extends 'SyForm::Exception';

with qw(
  SyForm::Exception::Role::WithOriginalError
  SyForm::Exception::Role::WithCreateArgs
);

sub throw_with_args {
  my ( $class, $create_args, $error ) = @_;
  $class->rethrow_syform_exception($error);
  $class->throw($class->error_message_text($error).' on create',
    create_args => $create_args,
    original_error => $error,
  );
}

1;