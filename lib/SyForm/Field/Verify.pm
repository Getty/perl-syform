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

sub BUILD {
  my ( $self ) = @_;
  $self->syform->add_role('SyForm::Verify');
}

1;