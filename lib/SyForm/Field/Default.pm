package SyForm::Field::Default;
# ABSTRACT: A default for a field

use Moose::Role;
use SyForm::Exception::UnexpectedCallToGetValueByArgs;
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

around get_value_by_args => sub {
  my ( $orig, $self, %args ) = @_;
  return $self->$orig(%args) if $self->has_value_by_args(%args);
  return $self->default if $self->has_default;
  SyForm::Exception::UnexpectedCallToGetValueByArgs->throw($self);
};

1;
