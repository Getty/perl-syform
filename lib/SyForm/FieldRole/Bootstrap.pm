package SyForm::FieldRole::Bootstrap;
# ABSTRACT: SyForm::ViewFieldRole::Bootstrap configuration of the field

use Moo::Role;

has bootstrap => (
  is => 'ro',
  predicate => 1,
);

# Should be somewhere else
has help => (
  is => 'ro',
  predicate => 1,
);

1;
