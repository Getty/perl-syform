package SyForm::Role::HTML;
# ABSTRACT: SyForm::View::HTML configuration of the form

use Moo::Role;

has target => (
  is => 'ro',
  predicate => 1,
);

1;
