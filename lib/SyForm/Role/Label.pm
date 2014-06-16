package SyForm::Role::Label;
# ABSTRACT: A label for the form

use Moo::Role;

has label => (
  is => 'ro',
  predicate => 1,
);

1;
