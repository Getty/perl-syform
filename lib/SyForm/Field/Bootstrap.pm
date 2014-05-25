package SyForm::Field::Bootstrap;
# ABSTRACT: Bootstrap attributes for the field

use Moose::Role;
use namespace::clean -except => 'meta';

with qw(
  SyForm::Field::HTML
);

has '+html' => (
  required => 0,
  lazy_build => 1,
);

sub _build_html {
  my ( $self ) = @_;
  return $self->bootstrap;
}

has bootstrap => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);

1;
