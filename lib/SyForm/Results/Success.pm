package SyForm::Results::Success;
# ABSTRACT:

use Moose::Role;
use namespace::autoclean;

# use MooseX::Role::WithOverloading;
# use overload q{bool} => sub { $_[0]->success };

has success => (
  is => 'ro',
  isa => 'Bool',
  required => 1,
);

1;