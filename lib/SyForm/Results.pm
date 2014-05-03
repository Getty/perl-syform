package SyForm::Results;

use Moose::Role;
use namespace::autoclean;

with qw(
  MooseX::Traits
  SyForm::Fields
);

# TODO
# use MooseX::Role::WithOverloading;
# use overload q{%{}} => 'as_hashref';

has values => (
  is => 'ro',
  does => 'SyForm::Values',
  required => 1,
  handles => [qw(
    syform
    field
  )],
);

sub get_result {
  my ( $self, $name ) = @_;
  $self->$name;
}

sub has_result {
  my ( $self, $name ) = @_;
  my $has_name = 'has_'.$name;
  $self->$has_name;
}

1;