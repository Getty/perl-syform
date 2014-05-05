package SyForm::Meta::Attribute::Field;
# ABSTRACT: Role for SyForm fields meta attributes

use Moose::Role;
use namespace::clean -except => 'meta';

has field => (
  is => 'ro',
  does => 'SyForm::Field',
  required => 1,
  handles => [qw(
    syform
  )],
);

1;