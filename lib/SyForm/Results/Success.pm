package SyForm::Results::Success;
# ABSTRACT:

use MooseX::Role::WithOverloading;
use overload q{bool} => sub { $_[0]->success ? 1 : 0 }, fallback => 1;
use namespace::clean;

has success => (
  is => 'ro',
  isa => 'Bool',
  required => 1,
);

1;