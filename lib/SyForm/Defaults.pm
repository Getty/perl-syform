package SyForm::Defaults;

use Moose::Role;

around process => sub {
  my ( $orig, $self, %args ) = @_;
  for my $name ($self->fields->Keys) {
    my $field = $self->fields->FETCH($name);
    if ($field->does('SyForm::Field::Default')
      && $field->has_default && !exists $args{$name}) {
      $args{$name} = $field->default;
    }
  }
  return $self->$orig(%args);
};

1;