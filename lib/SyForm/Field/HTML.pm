package SyForm::Field::HTML;
# ABSTRACT: HTML attributes for a field

use Moose::Role;
use namespace::autoclean;

has html => (
  is => 'rw',
  isa => 'Str',
  required => 1,
);

has input_attrs => (
  is => 'rw',
  isa => 'HashRef[Str|ArrayRef[Str]]',
  lazy_build => 1,
);

sub _build_input_attrs {
  my ( $self ) = @_; 
  return {};
}

1;
