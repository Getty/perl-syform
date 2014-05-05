package SyForm::Fields;
# ABSTRACT: Role for SyForm::Values and SyForm::Results holding the fields

use Moose::Role;
use namespace::clean -except => 'meta';

requires 'as_hashref';

has field_names => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  required => 1,
);

1;