package SyForm::Field::Verify;
# ABSTRACT: Required field

use Moose::Role;
use Moose::Util qw( apply_all_roles );
use namespace::autoclean;

has required => (
  is => 'ro',
  isa => 'Bool',
  predicate => 'has_required',
);

has type => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_type',
);

has verify_filters => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  predicate => 'has_verify_filters',
);

sub BUILD {
  my ( $self ) = @_;
  apply_all_roles( $self->syform, 'SyForm::Verify' ) unless $self->syform->does('SyForm::Verify');
}

1;
