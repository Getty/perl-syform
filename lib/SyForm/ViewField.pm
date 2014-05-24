package SyForm::ViewField;
# ABSTRACT: Role for fields inside a SyForm::View

use Moose::Role;
use namespace::clean -except => 'meta';

with qw(
  MooseX::Traits
);

has view => (
  is => 'ro',
  isa => 'SyForm::View',
  required => 1,
  handles => [qw(
    viewfield
    results
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

1;
