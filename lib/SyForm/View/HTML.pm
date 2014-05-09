package SyForm::View::HTML;
# ABSTRACT:

use Moose::Role;
use namespace::clean -except => 'meta';

has render => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_render {
  my ( $self ) = @_;
  my $html = $self->form_open;
  for my $key ($self->syform->fields->Keys) {
    if (defined $self->fields->{$key}) {
      $html .= $self->fields->{$key}->render;
    }
  }
  $html .= $self->submit;
  $html .= $self->form_close;
  return $html;
}

has form_open => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_form_open {
  my ( $self ) = @_;
  my $form = '<form';
  my %attributes = %{$self->html_attributes};
  if (scalar keys %attributes) {
    my @attrs;
    for my $key (sort { $a cmp $b } keys %attributes) {
      my $value = $attributes{$key};
      push @attrs, $key.'="'.$value.'"';
    }
    $form .= " ".join(" ",@attrs);
  }
  $form .= '>'."\n";
}

has form_close => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_form_close {
  my ( $self ) = @_;
  return '</form>';
}

has html_attributes => (
  is => 'ro',
  isa => 'HashRef',
  lazy_build => 1,
);

sub _build_html_attributes {
  my ( $self ) = @_;
  my %args = %{$self->syform->html_attributes};
  $args{method} = $self->syform->method unless defined $args{method};
  return { %args };
}

has submit => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_submit {
  my ( $self ) = @_;
  my %attributes = %{$self->submit_attributes};
  my $html_tag = delete $attributes{html_tag};
  my $submit = '<'.$html_tag;
  if (scalar keys %attributes) {
    my @attrs;
    for my $key (sort { $a cmp $b } keys %attributes) {
      my $value = $attributes{$key};
      push @attrs, $key.'="'.$value.'"';
    }
    $submit .= " ".join(" ",@attrs);
  }
  $submit .= '>'."\n";
  return $submit;
}

has submit_attributes => (
  is => 'ro',
  isa => 'HashRef',
  lazy_build => 1,
);

sub _build_submit_attributes {
  my ( $self ) = @_;
  return {
    html_tag => $self->syform->submit_html_tag,
    type => 'submit',
    value => $self->syform->submit_value,
    $self->syform->has_name ? (
      name => 'submit_'.$self->syform->name,
    ) : (),
    %{$self->syform->submit_attributes}
  };
}

1;
