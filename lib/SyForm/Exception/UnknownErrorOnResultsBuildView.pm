package SyForm::Exception::UnknownErrorOnResultsBuildView;

use Moose;
extends 'SyForm::Exception';

with qw(
  SyForm::Exception::Role::WithSyFormResults
  SyForm::Exception::Role::WithOriginalError
);

sub throw_with_args {
  my ( $class, $results, $original_error ) = @_;
  $class->rethrow_syform_exception($original_error);
  $class->throw($class->error_message_text($original_error).' on build of view',
    original_error => $original_error,
    results => $results,
  );
};

1;