package SyForm::ResultsRole::Success;
# ABSTRACT: A bool for holding the success of the form process

use Moo::Role;

has success => (
  is => 'ro',
  required => 1,
);

1;