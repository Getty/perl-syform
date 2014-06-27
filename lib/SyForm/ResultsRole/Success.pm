package SyForm::ResultsRole::Success;
# ABSTRACT: A bool for holding the success of the form process

use Moo::Role;

use overload 'bool' => sub { $_[0]->success };

has success => (
  is => 'ro',
  required => 1,
);

1;