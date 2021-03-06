package SyForm::Exception::UnknownErrorOnProcess;
# ABSTRACT: Exception on SyForm::Process->process

use Moo;
extends 'SyForm::Exception';

with qw(
  SyForm::Exception::Role::WithSyForm
  SyForm::Exception::Role::WithOriginalError
);

has process_args => (
  is => 'ro',
  required => 1,
);

sub throw_with_args {
  my ( $class, $syform, $process_args, $error ) = @_;
  $class->rethrow_syform_exception($error);
  $class->throw($class->error_message_text($error).' on process',
    syform => $syform,
    original_error => $error,
    process_args => $process_args,
  );
};

1;