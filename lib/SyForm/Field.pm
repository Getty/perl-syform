package SyForm::Field;
# ABSTRACT: Role for fields in SyForm

use Moose::Role;
use namespace::clean -except => 'meta';

with qw(
  MooseX::Traits
);

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

has has_name => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);
sub _build_has_name { 'has_'.($_[0]->name) }

1;
