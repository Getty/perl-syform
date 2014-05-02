package SyForm::Fields;

use Moose::Role;
use namespace::autoclean;

sub as_hashref {
  my ( $self ) = @_;
  my %hashref;
  for my $name (@{$self->field_names}) {
    my $has = 'has_'.$name;
    $hashref{$name} = $self->$name if $self->$has;
  }
  return { %hashref };
}

has field_names => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  required => 1,
);

1;