package SyForm::FieldRole::Default;
# ABSTRACT: A default for the field

use Moo::Role;

has default => (
  is => 'ro',
  predicate => 1,
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
