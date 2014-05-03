package SyForm::View::Success;
# ABSTRACT:

use Moose::Role;
use namespace::autoclean;

# TODO
# use MooseX::Role::WithOverloading;
# use overload q{bool} => 'success';

has success => (
  is => 'ro',
  isa => 'Bool',
  lazy_build => 1,
);

sub _build_success {
  my ( $self ) = @_;
  return $self->results->does('SyForm::Results::Success')
    ? $self->results->success
    : 1;
}

1;