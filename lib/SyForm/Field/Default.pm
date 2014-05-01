package SyForm::Field::Default;
# ABSTRACT: A default for a field

use Moose::Role;
use Moose::Util qw( apply_all_roles );
use namespace::autoclean;

has default => (
  is => 'ro',
  predicate => 'has_default',
);

sub BUILD {
  my ( $self ) = @_;
  apply_all_roles( $self->syform, 'SyForm::Defaults' ) unless $self->syform->does('SyForm::Defaults');
}

1;
