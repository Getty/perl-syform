package SyForm::Role::Bootstrap;
# ABSTRACT: SyForm::ViewRole::Bootstrap configuration of the form

use Moo::Role;

has bootstrap => (
  is => 'ro',
  predicate => 1,
);

has bootstrap_submit => (
  is => 'ro',
  predicate => 1,
);

has bootstrap_submit_attributes => (
  is => 'ro',
  predicate => 1,
);

1;
