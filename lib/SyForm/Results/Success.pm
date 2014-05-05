package SyForm::Results::Success;
# ABSTRACT: A bool for holding the success of the form process

use MooseX::Role::WithOverloading;
use namespace::clean -except => 'meta';
use overload q{bool} => sub { $_[0]->success ? 1 : 0 }, fallback => 1;

has success => (
  is => 'ro',
  isa => 'Bool',
  required => 1,
);

1;