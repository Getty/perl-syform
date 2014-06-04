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

has syccess => (
  is => 'ro',
  isa => 'HashRef',
  predicate => 'has_syccess',
);

1;
