package SyForm::Field::Default;
# ABSTRACT: A default for a field

use Moose::Role;
use namespace::autoclean;

with qw(
  SyForm::Field::Process
);

has default => (
  is => 'ro',
  predicate => 'has_default',
);

around has_value_by_args => sub {
  my ( $orig, $self, %args ) = @_;
  return 1 if $self->$orig(%args);
  return 1 if $self->has_default;
  return 0;
};

around get_value_by_process_args => sub {
  my ( $orig, $self, %args ) = @_;
  return $self->default if !exists($args{$self->name}) && $self->has_default;
  return $self->$orig(%args);
};

1;
