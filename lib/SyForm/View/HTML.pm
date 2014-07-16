package SyForm::View::HTML;

use Moo;

with qw(
  SyForm::ViewRole
  SyForm::ViewRole::Success
  SyForm::ViewRole::Verify
);

has submit_attributes => (
  is => 'lazy',
);

sub _build_submit_attributes {
  my ( $self ) = @_;
  my $name = $self->syform->name;
  return {
    value => $self->syform->has_submit_value
      ? $self->syform->submit_value : 'Submit',
    $self->syform->has_name ? (
      name => $name,
      id => $name,
    ) : (),
  };
}

has no_submit => (
  is => 'lazy',
);

sub _build_no_submit {
  my ( $self ) = @_;
  return $self->field->no_submit;
}

has form_attributes => (
  is => 'lazy',
);

sub _build_form_attributes {
  my ( $self ) = @_;
  return {
    role => 'form',
    $self->syform->has_target ? (
      target => $self->syform->target
    ) : (),
    $self->syform->has_method ? (
      method => $self->syform->method
    ) : (),
  };
}

1;
