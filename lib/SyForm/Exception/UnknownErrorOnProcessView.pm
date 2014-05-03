package SyForm::Exception::UnknownErrorOnProcessView;

use Moose;
extends 'SyForm::Exception';

with qw(
  SyForm::Exception::Role::WithSyForm
  SyForm::Exception::Role::WithOriginalError
);

has process_view_args => (
  is => 'ro',
  isa => 'ArrayRef',
  required => 1,
);

sub throw_with_args {
  my ( $class, $syform, $process_view_args, $original_error ) = @_;
  $class->rethrow_syform_exception($original_error);
  $class->throw($class->error_message_text($original_error).' on process_view',
    syform => $syform,
    original_error => $original_error,
    process_view_args => $process_view_args,
  );
};

1;