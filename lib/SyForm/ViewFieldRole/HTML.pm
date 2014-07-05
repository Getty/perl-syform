package SyForm::ViewFieldRole::HTML;
# ABSTRACT: 

use Moo::Role;
use SyForm::ViewField::InputHTML;
use SyForm::ViewField::LabelHTML;

has html_name => (
  is => 'lazy',
);

sub _build_html_name {
  my ( $self ) = @_;
  return $self->field->name;
}

has html_id => (
  is => 'lazy',
);

sub _build_html_id {
  my ( $self ) = @_;
  return $self->html_name;
}

sub has_syform_formhtml_children { 1 }

has syform_formhtml_children => (
  is => 'lazy',
);

sub _build_syform_formhtml_children {
  my ( $self ) = @_;
  return [
    $self->syform_viewfield_inputhtml,
    $self->has_label ? ( $self->syform_viewfield_labelhtml ) : (),
  ];
}

has syform_viewfield_inputhtml => (
  is => 'lazy',
);

sub _build_syform_viewfield_inputhtml {
  my ( $self ) = @_;
  return SyForm::ViewField::InputHTML->new(
    type => 'text',
    name => $self->html_name,
    id => $self->html_id,
    $self->has_label ? ( title => $self->label ) : (),
    $self->has_val ? ( value => $self->val ) : (),
    $self->field->has_input ? ( %{$self->field->input} ) : (),
  );
}

has syform_viewfield_labelhtml => (
  is => 'lazy',
);

sub _build_syform_viewfield_labelhtml {
  my ( $self ) = @_;
  SyForm->throw('Require label for labelhtml') unless $self->has_label;
  return SyForm::ViewField::LabelHTML->new(
    for => $self->html_id,
    label => $self->label,
    $self->is_invalid ? ( errors => $self->errors ) : (),
  );
}

1;