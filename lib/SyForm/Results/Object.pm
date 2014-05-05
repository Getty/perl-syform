package SyForm::Results::Object;
# ABSTRACT: Functionality for SyForm::Results to deliver a Moose object

use Moose::Role;
use namespace::clean -except => 'meta';

has object => (
  is => 'ro',
  isa => 'Moose::Object',
  lazy_build => 1,
);

sub _build_object {
  my ( $self ) = @_;
  return $self->syform->fields_object_class->new($self->as_hashref);
}

1;