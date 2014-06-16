package SyForm::ViewRole::Success;
# ABSTRACT: Fetching success value from SyForn::Results of give back true

use Moo::Role;

has success => (
  is => 'lazy',
);

sub _build_success {
  my ( $self ) = @_;
  return $self->results->does('SyForm::ResultsRole::Success')
    ? $self->results->success : 1;
}

1;