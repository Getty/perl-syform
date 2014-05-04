package SyForm::Label;
# ABSTRACT: A label for a form

use Moose::Role;
use namespace::autoclean;

has label => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_label',
);

1;