package SyForm::FieldRole::HTML;
# ABSTRACT: SyForm::ViewFieldRole::HTML configuration of the field

use Moo::Role;

has disabled => (
  is => 'lazy',
);

sub _build_disabled { return 0; }

has placeholder => (
  is => 'lazy',
  predicate => 1,
);

has label_attributes => (
  is => 'ro',
  predicate => 1,
);

has input_attributes => (
  is => 'ro',
  predicate => 1,
);

1;
