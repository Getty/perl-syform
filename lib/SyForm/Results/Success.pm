package SyForm::Results::Success;
# ABSTRACT: A bool for holding the success of the form process

use Moose::Role;
#use overload q{bool} => sub { $_[0]->success ? 1 : 0 }, fallback => 1;
use namespace::clean -except => 'meta';

has success => (
  is => 'ro',
  isa => 'Bool',
  required => 1,
);

1;