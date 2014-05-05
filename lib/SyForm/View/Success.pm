package SyForm::View::Success;
# ABSTRACT: Fetching success value from SyForn::Results of give back true

use MooseX::Role::WithOverloading;
use namespace::clean -except => 'meta';
use overload q{bool} => sub { $_[0]->success ? 1 : 0 }, fallback => 1;

has success => (
  is => 'ro',
  isa => 'Bool',
  lazy_build => 1,
);

sub _build_success {
  my ( $self ) = @_;
  return $self->results->does('SyForm::Results::Success')
    ? $self->results->success : 1;
}

1;