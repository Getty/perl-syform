package SyForm::View::Success;
# ABSTRACT:

use MooseX::Role::WithOverloading;
use overload q{bool} => sub { $_[0]->success ? 1 : 0 }, fallback => 1;
use namespace::clean;

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