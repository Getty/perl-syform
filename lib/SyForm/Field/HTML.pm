package SyForm::Field::HTML;
# ABSTRACT: HTML attributes for the field

use Moose::Role;
use namespace::clean -except => 'meta';

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
