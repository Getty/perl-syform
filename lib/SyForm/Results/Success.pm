package SyForm::Results::Success;
# ABSTRACT:

use Moose::Role;
use namespace::autoclean;

# TODO
# use MooseX::Role::WithOverloading;
# use overload q{bool} => 'success';

has success => (
  is => 'ro',
  isa => 'Bool',
  required => 1,
);

1;