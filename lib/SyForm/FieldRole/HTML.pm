package SyForm::FieldRole::HTML;
# ABSTRACT: SyForm::ViewFieldRole::HTML configuration of the field

use Moo::Role;

has input => (
  is => 'ro',
  predicate => 1,
);

has html_label => (
  is => 'ro',
  predicate => 1,
);

1;
