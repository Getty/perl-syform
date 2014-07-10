package SyForm::ViewFieldRole::Bootstrap;
# ABSTRACT: 

use Moo::Role;
use SyForm::ViewField::FormGroupBootstrap;

sub has_syform_formbootstrap_children { 1 }

has syform_formbootstrap_children => (
  is => 'lazy',
);

sub _build_syform_formbootstrap_children {
  my ( $self ) = @_;
  return [
    $self->syform_viewfield_formgroupbootstrap,
  ];
}

has syform_viewfield_formgroupbootstrap => (
  is => 'lazy',
);

sub _build_syform_viewfield_formgroupbootstrap {
  my ( $self ) = @_;
  return SyForm::ViewField::FormGroupBootstrap->new(
    syform_formbootstrap => $self->view->syform_formbootstrap,
    syform_viewfield_inputhtml => $self->syform_viewfield_inputhtml,
    syform_viewfield_labelhtml => $self->syform_viewfield_labelhtml,
    $self->field->has_help ? ( help => $self->field->help ) : (),
    $self->field->has_bootstrap ? ( %{$self->field->bootstrap} ) : (),
  );
}

1;