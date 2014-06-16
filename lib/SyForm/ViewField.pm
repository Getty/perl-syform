package SyForm::ViewField;
# ABSTRACT: View fields inside a SyForm::View

use Moo;

with qw(
  MooX::Traits
);

has field => (
  is => 'ro',
  predicate => 1,
);

has view => (
  is => 'ro',
  required => 1,
  handles => [qw(
    viewfields
    fields
    syform
    results
    values
  )],
);

has name => (
  is => 'ro',
  required => 1,
);

has has_name => (
  is => 'lazy',
);
sub _build_has_name { 'has_'.($_[0]->name) }

has label => (
  is => 'ro',
  predicate => 1,
);

has value => (
  is => 'ro',
  predicate => 1,
);

has result => (
  is => 'ro',
  predicate => 1,
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
