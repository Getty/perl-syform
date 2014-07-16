package SyForm::ViewFieldRole::HTML;
# ABSTRACT: 

use Moo::Role;

has input_attributes => (
  is => 'lazy',
);

sub _build_input_attributes {
  my ( $self ) = @_;
  my $name = $self->field->name;
  return {
    name => $name,
    id => $name,
    $self->field->required ? (
      required => "required",
    ) : (),
    $self->field->has_placeholder ? (
      placeholder => $self->field->placeholder
    ) : (),
    $self->field->disabled ? (
      disabled => "disabled"
    ) : (),
    $self->field->has_input_attributes ? (
      %{$self->field->input_attributes}
    ) : (),
  };
}

has label_attributes => (
  is => 'lazy',
);

sub _build_label_attributes {
  my ( $self ) = @_;
  return {
    for => $self->field->name,
    $self->field->has_label_attributes ? (
      %{$self->field->label_attributes}
    ) : (),
  };
}

1;