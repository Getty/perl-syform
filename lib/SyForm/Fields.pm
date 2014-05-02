package SyForm::Fields;

use Moose::Role;
use namespace::autoclean;

sub as_hashref {
  my ( $self ) = @_;
  my %hashref;
  for my $meta_attribute ($self->meta->get_all_attributes) {
    if ($meta_attribute->does('SyForm::Meta::Attribute::Field')) {
      my $name = $meta_attribute->name;
      my $has = 'has_'.$name;
      $hashref{$name} = $self->$name if $self->$has;
    }
  }
  return { %hashref };
}

1;