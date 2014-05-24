package SyForm::Field::HTML;
# ABSTRACT: HTML attributes for the field

use Moose::Role;
use namespace::clean -except => 'meta';

has html => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);

has placeholder => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_placeholder',
);

has html_attributes => (
  is => 'ro',
  isa => 'HashRef[Str]',
  lazy_build => 1,
);

sub _build_html_attributes {
  my ( $self ) = @_;
  return {
    $self->has_placeholder ? (
      placeholder => $self->placeholder,
    ) : (),
  };
}

has html_name => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_html_name {
  my ( $self ) = @_;
  return $self->name;
}

1;
