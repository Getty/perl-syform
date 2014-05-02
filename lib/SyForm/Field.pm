package SyForm::Field;
# ABSTRACT: Role for fields in SyForm

use Moose::Role;

has syform => (
  is => 'ro',
  isa => 'SyForm',
  weak_ref => 1,
  required => 1,
);

has name => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);

1;
