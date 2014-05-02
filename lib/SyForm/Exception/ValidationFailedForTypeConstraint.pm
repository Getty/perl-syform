package SyForm::Exception::ValidationFailedForTypeConstraint;

use Moose;
extends 'SyForm::Exception';

has moose_exception => (
  isa => 'Moose::Exception::ValidationFailedForTypeConstraint',
  is => 'ro',
  required => 1,
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
  my ( $class, $field_name, $field_args, $moose_exception ) = @_;
  my $message = $moose_exception->is_attribute_set
    ? 'On field ('.$field_name.') the '.lcfirst($moose_exception->message)
    : 'Moose exception at field ('.$field_name.'): '.$moose_exception->message;
  $class->throw($message,
    field_args => $field_args,
    field_name => $field_name,
    moose_exception => $moose_exception,
  );
};

1;