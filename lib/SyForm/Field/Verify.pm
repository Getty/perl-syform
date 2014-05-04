package SyForm::Field::Verify;
# ABSTRACT: Required field

use Moose::Role;
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

has no_delete_on_invalid_result => (
  is => 'ro',
  isa => 'Bool',
  default => sub { 0 },
);

around results_roles_by_values => sub {
  my ( $orig, $self, $values ) = @_;
  return $self->$orig($values), qw(
    SyForm::Results::Success
    SyForm::Results::Verify
  );
};

around viewfield_roles_by_results => sub {
  my ( $orig, $self, $results ) = @_;
  return $self->$orig($results), qw(
  );
};

around view_roles_by_results => sub {
  my ( $orig, $self, $results ) = @_;
  return $self->$orig($results), qw(
    SyForm::View::Success
  );
};

1;
