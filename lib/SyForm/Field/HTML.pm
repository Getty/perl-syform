package SyForm::Field::HTML;
# ABSTRACT: HTML attributes for the field

use Moose::Role;
use namespace::clean -except => 'meta';

has html => (
  is => 'rw',
  isa => 'Str',
  required => 1,
);

has custom_html_input_attributes => (
  is => 'rw',
  isa => 'HashRef[Str]',
  default => sub {{}},
);

around viewfield_roles_by_results => sub {
  my ( $orig, $self, $results ) = @_;
  return $self->$orig($results), qw( SyForm::ViewField::HTML );
};

has html_name => (
  is => 'rw',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_html_name {
  my ( $self ) = @_;
  return $self->name;
}

1;
