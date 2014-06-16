package SyForm::Exception::UnknownErrorOnCreateValuesByArgs;
# ABSTRACT: Exception on SyForm::Process->create_values_by_args

use Moo;
extends 'SyForm::Exception';

with qw(
  SyForm::Exception::Role::WithSyForm
  SyForm::Exception::Role::WithOriginalError
);

has args => (
  is => 'ro',
  required => 1,
);

sub throw_with_args {
  my ( $class, $syform, $args, $original_error ) = @_;
  $class->rethrow_syform_exception($original_error);
  $class->throw($class->error_message_text($original_error).' on create_values_by_args',
    syform => $syform,
    original_error => $original_error,
    args => $args,
  );
};

1;