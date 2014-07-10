package SyForm::ViewFieldRole::HTML;
# ABSTRACT: 

use Moo::Role;

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

1;