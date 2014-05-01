package SyForm::Field::Process;
# ABSTRACT: Role for processed fields

use Moose::Role;

has result => (
  is => 'rw',
  predicate => 'has_result',
  clearer => 'reset_result',
);

sub set_result {
  my ( $self, $value ) = @_;
  $self->result($value);
}

sub process {
  my ( $self, %args ) = @_;
  if (exists $args{$self->name}) {
    $self->set_result($args{$self->name});
  }
  return 1;
}

1;
