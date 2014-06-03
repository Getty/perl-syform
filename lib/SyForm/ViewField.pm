package SyForm::ViewField;
# ABSTRACT: View fields inside a SyForm::View

use Moose;
use namespace::clean -except => 'meta';

with qw(
  MooseX::Traits
);

has field => (
  is => 'ro',
  isa => 'SyForm::Field',
  predicate => 'has_field',
);

has view => (
  is => 'ro',
  isa => 'SyForm::View',
  required => 1,
  handles => [qw(
    viewfield
    viewfields
    field
    fields
    syform
  )],
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
  predicate => 'has_field',
);

has value => (
  is => 'ro',
  predicate => 'has_value',
);

has result => (
  is => 'ro',
  predicate => 'has_result',
);

sub val {
  my ( $self ) = @_;
  return $self->result if $self->has_result;
  return $self->value if $self->has_value;
  return;
}

sub has_val {
  my ( $self ) = @_;
  return 1 if $self->has_result;
  return 1 if $self->has_value;
  return 0;
}

1;
