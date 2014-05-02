package SyForm::Field::Process;
# ABSTRACT: Role for processed fields

use Moose::Role;
use namespace::autoclean;

sub has_value_by_args {
  my ( $self, %args ) = @_;
  return exists($args{$self->name}) ? 1 : 0;
}

sub get_value_by_args {
  my ( $self, %args ) = @_;
  SyForm->throw( UnexpectedCallToGetValueByArgs => $self )
    unless $self->has_value_by_args(%args);
  return $self->get_value_by_arg($args{$self->name});
}

sub get_value_by_arg {
  my ( $self, $arg ) = @_;
  return $arg;
}

sub has_result_by_values {
  my ( $self, $values ) = @_;
  my $has = 'has_'.($self->name);
  return $values->$has ? 1 : 0;
}

sub get_result_by_values {
  my ( $self, $values ) = @_;
  return unless $self->has_result_by_values($values);
  my $name = $self->name;
  return $self->get_result_by_value($values->$name);
}

sub get_result_by_value {
  my ( $self, $value ) = @_;
  return $value;
}

1;
