package SyForm::Verify;
# ABSTRACT: Main verification logic

use Moose::Role;
use namespace::clean -except => 'meta';

has verify_without_errors => (
  is => 'ro',
  isa => 'Bool',
  lazy => 1,
  default => sub { 0 },
);

has verify_process_fields => (
  is => 'ro',
  isa => 'ArrayRef[SyForm::Field]',
  lazy_build => 1,
);

sub _build_verify_process_fields {
  my ( $self ) = @_;
  return [grep { $_->does('SyForm::Field::Verify') } @{$self->process_fields}];
}

has syccess => (
  is => 'ro',
  isa => 'HashRef',
  predicate => 'has_syccess',
);

1;
