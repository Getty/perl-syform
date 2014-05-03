package SyForm::ViewField;
# ABSTRACT: Role for fields inside a View

use Moose::Role;

has view => (
  is => 'ro',
  isa => 'SyForm::View',
  required => 1,
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

1;
