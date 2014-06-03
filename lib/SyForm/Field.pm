package SyForm::Field;
# ABSTRACT: Role for fields in SyForm

use Moose;
use namespace::clean -except => 'meta';

with qw(
  MooseX::Traits
  SyForm::Field::Process
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

has label => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_label {
  my ( $self ) = @_;
  return ucfirst($self->name);
}

1;
