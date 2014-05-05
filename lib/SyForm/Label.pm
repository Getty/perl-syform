package SyForm::Label;
# ABSTRACT: A label for the form

use Moose::Role;
use namespace::clean -except => 'meta';

has label => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_label',
);

1;
