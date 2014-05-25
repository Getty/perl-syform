package SyForm::ViewField::HTML;
# ABSTRACT: HTML viewfield of a HTML field

use Moose::Role;
use List::MoreUtils qw( natatime );
use HTML::Declare ':all';
use namespace::clean -except => 'meta';

has html => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_html {
  my ( $self ) = @_;
  return $self->field->html;
}

has html_name => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_html_name {
  my ( $self ) = @_;
  return $self->field->html_name;
}

has html_id => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_html_id {
  my ( $self ) = @_;
  return $self->field->html_id;
}

has html_label_attributes => (
  is => 'ro',
  isa => 'HashRef[Str]',
  lazy_build => 1,
);

sub _build_html_label_attributes {
  my ( $self ) = @_;
  return {
    for => $self->html_id,
  };
}

has html_label => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_html_label {
  my ( $self ) = @_;
  my %attributes = %{$self->html_label_attributes};
  return LABEL({
    %attributes,
    _ => $self->label,
  })->as_html;
}

has html_input_attributes => (
  is => 'ro',
  isa => 'HashRef',
  lazy_build => 1,
);

sub _build_html_input_attributes {
  my ( $self ) = @_;
  my %form_attributes = %{$self->field->syform->html_input_attributes};
  my %attributes = %{$self->field->html_input_attributes};
  return {
    type => $self->html,
    name => $self->html_name,
    id => $self->html_id,
    %form_attributes,
    %attributes,
  };
}

has html_input => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_html_input {
  my ( $self ) = @_;
  my %attributes = %{$self->html_input_attributes};
  return INPUT({
    %attributes,
  })->as_html;
}

has html_render => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_html_render {
  my ( $self ) = @_;
  return $self->html_label.$self->html_input;
}

1;
