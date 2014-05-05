package SyForm::Exception::UnexpectedArgToCreate;
# ABSTRACT: Arguments given to SyForm->create are invalid

use Moose;
extends 'SyForm::Exception';

with qw(
  SyForm::Exception::Role::WithCreateArgs
);

has error_ref => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);

sub throw_with_args {
  my ( $class, $create_args, $ref ) = @_;
  $class->throw('Unexpected parameter to create with reference type ('.
    $ref.').',
    create_args => $create_args,
    error_ref => $ref,
  );
};

1;