package SyForm::ResultsRole::Verify;
# ABSTRACT: Trait for SyForm fields of SyForm::Results and SyForm::Values attributes

use Moo::Role;

requires qw(
  success
);

has syccess_result => (
  is => 'ro',
  required => 1,
);

has error_count => (
  is => 'lazy',
);

sub _build_error_count {
  my ( $self ) = @_;
  $self->syccess_result->error_count;
}

1;