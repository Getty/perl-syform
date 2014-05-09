package SyForm::ViewField::Label;
# ABSTRACT: Label ViewField for a Label Field

use Moose::Role;
use namespace::clean -except => 'meta';

# TODO: Should be actually more optional, only loaded with HTML context
# or probably splitting up into additional HTML::Label role?

has label => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_label {
  my ( $self ) = @_;
  return $self->field->label;
}

around _build_render => sub {
  my ( $orig, $self ) = @_;
  my $original_render = $self->$orig;
  my $label = '<label for="'.$self->html_name.'">';
  $label .= $self->label.'</label>';
  return $label.$original_render;
};

1;
