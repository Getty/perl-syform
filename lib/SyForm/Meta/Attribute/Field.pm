package SyForm::Meta::Attribute::Field;
# ABSTRACT: Role for SyForm fields of SyForm::Results and SyForm::Values meta attributes

use Moose::Role;
use namespace::autoclean;

has field => (
  is => 'ro',
  isa => 'SyForm::Field',
  required => 1,
  handles => [qw(
    syform
  )],
);

1;