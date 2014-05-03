package SyForm::Exception::UnknownErrorOnProcessResults;

use Moose;
extends 'SyForm::Exception';

with qw(
  SyForm::Exception::Role::WithSyForm
  SyForm::Exception::Role::WithOriginalError
);

has process_results_args => (
  is => 'ro',
  isa => 'ArrayRef',
  required => 1,
);

sub throw_with_args {
  my ( $class, $syform, $process_results_args, $original_error ) = @_;
  $class->rethrow_syform_exception($original_error);
  $class->throw($class->error_message_text($original_error).' on process_results',
    syform => $syform,
    original_error => $original_error,
    process_results_args => $process_results_args,
  );
};

1;