package SyForm::Field::Label;
# ABSTRACT: A label for the field

use Moose::Role;
use namespace::clean -except => 'meta';

has label => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_label {
  my ( $self ) = @_;
  return ucfirst($self->name);
}

1;
