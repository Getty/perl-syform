package SyForm::Exception::OddNumberOfArgsOnCreateValuesByArgs;
# ABSTRACT: Exception on SyForm::Process->create_values_by_args

use Moo;
extends 'SyForm::Exception';

with qw(
  SyForm::Exception::Role::WithSyForm
);

has process_args => (
  is => 'ro',
  required => 1,
);

sub throw_with_args {
  my ( $class, $syform, $process_args, $error ) = @_;
  $class->rethrow_syform_exception($error);
  $class->throw('Odd number of elements on args of create_values_by_args',
    syform => $syform,
    process_args => $process_args,
  );
};

1;