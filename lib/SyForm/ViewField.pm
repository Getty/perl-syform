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
  )],
);

has field => (
  is => 'ro',
  isa => 'SyForm::Field',
  required => 1,
  handles => [qw(
    syform
  )],
);

sub has_value {
  my ( $self ) = @_;
  my $name = $self->field->name;
  $self->results->values->has_value($name);
}

sub value {
  my ( $self ) = @_;
  my $name = $self->field->name;
  $self->results->values->get_value($name);
}

sub has_result {
  my ( $self ) = @_;
  my $name = $self->field->name;
  $self->results->has_result($name);
}

sub result {
  my ( $self ) = @_;
  my $name = $self->field->name;
  $self->results->get_result($name);
}

sub val {
  my ( $self ) = @_;
  return $self->result if $self->has_result;
  return $self->value if $self->has_value;
}

1;
