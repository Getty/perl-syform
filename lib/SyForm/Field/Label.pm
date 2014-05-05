package SyForm::Field::Label;
# ABSTRACT: A label for the field

use Moose::Role;
use namespace::clean -except => 'meta';

has label => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_label',
);

1;
