package SyForm::Results::Verify;
# ABSTRACT: Trait for SyForm fields of SyForm::Results and SyForm::Values attributes

use Moose::Role;
use namespace::autoclean;

has verify_results => (
  is => 'ro',
  isa => 'Data::Verifier::Results',
  required => 1,
);

1;