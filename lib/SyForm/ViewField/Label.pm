package SyForm::ViewField::Label;
# ABSTRACT: Label ViewField for a Label Field

use Moose::Role;
use namespace::clean -except => 'meta';

has label => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_label {
  my ( $self ) = @_;
  return $self->field->label;
}

has html_label => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_html_label {
  my ( $self ) = @_;
  my $label = '<label for="'.$self->html_name.'">';
  $label .= $self->label.'</label>';
  return $label;
}

1;
