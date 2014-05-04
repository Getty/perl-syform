package SyForm::Fields;

use Moose::Role;
use namespace::autoclean;

requires 'as_hashref';

has field_names => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  required => 1,
);

1;