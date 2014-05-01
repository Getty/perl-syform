package SyForm::Field::HTML;
# ABSTRACT: HTML attributes for a field

use Moose::Role;

has html => (
  is => 'rw',
  isa => 'Str',
  required => 1,
);

has input_attrs => (
  is => 'rw',
  isa => 'HashRef[Str|ArrayRef[Str]]',
  predicate => 'has_input_attrs',
);

1;
