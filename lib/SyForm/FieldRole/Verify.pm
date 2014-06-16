package SyForm::FieldRole::Verify;
# ABSTRACT: SyForm::Verify configuration of the field

use Moo::Role;

has verify => (
  is => 'ro',
  predicate => 1,
);

has delete_on_invalid_result => (
  is => 'lazy',
);

sub _build_delete_on_invalid_result {
  my ( $self ) = @_;
  return 1;
}

1;
