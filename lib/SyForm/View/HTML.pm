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
  $html .= $self->form_close;
  return $html;
}

has form_open => (
  is => 'rw',
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
  is => 'rw',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_form_close {
  my ( $self ) = @_;
  return '</form>';
}

has html_attributes => (
  is => 'rw',
  isa => 'HashRef',
  lazy_build => 1,
);

sub _build_html_attributes {
  my ( $self ) = @_;
  my %args = %{$self->syform->custom_html_attributes};
  $args{method} = $self->syform->method unless defined $args{method};
  return { %args };
}

1;
