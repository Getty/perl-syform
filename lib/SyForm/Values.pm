package SyForm::Values;

use Moose::Role;
use namespace::autoclean;

with qw(
  MooseX::Traits
  SyForm::Fields
);

has syform => (
  is => 'ro',
  isa => 'SyForm',
  required => 1,
  handles => [qw(
    field
  )],
);

sub get_value {
  my ( $self, $name ) = @_;
  $self->$name;
}

sub has_value {
  my ( $self, $name ) = @_;
  my $has_name = 'has_'.$name;
  $self->$has_name;
}

1;