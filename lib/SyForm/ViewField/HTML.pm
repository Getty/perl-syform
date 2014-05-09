package SyForm::ViewField::HTML;
# ABSTRACT: HTML viewfield of a HTML field

use Moose::Role;
use List::MoreUtils qw( natatime );
use namespace::clean -except => 'meta';

has html => (
  is => 'rw',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_html {
  my ( $self ) = @_;
  return $self->field->html;
}

has html_name => (
  is => 'rw',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_html_name {
  my ( $self ) = @_;
  return $self->field->html_name;
}

has html_inputs => (
  is => 'rw',
  isa => 'ArrayRef[Str|HashRef[Str]]',
  lazy_build => 1,
);

sub _build_html_inputs {
  my ( $self ) = @_;
  my $html_tag;
  my $html = $self->html;
  my %args = %{$self->field->custom_html_input_attributes};
  $html = delete $args{html} if defined $args{html};
  $args{name} = $self->html_name
    unless defined $args{name};
  my $has_result = $self->has_result;
  if ($html eq 'text') {
    $html_tag = 'input';
    $args{value} = $self->result if $has_result;
    $args{type} = 'text' unless defined $args{type};
  } elsif ($html eq 'hidden') {
    $html_tag = 'input';
    $args{value} = $self->result if $has_result;
    $args{type} = 'hidden' unless defined $args{type};
  } elsif ($html eq 'checkbox') {
    $html_tag = 'input';
    $args{checked} = 'checked' if $has_result && $self->result;
    $args{type} = 'checkbox' unless defined $args{type};
  } elsif ($html eq 'textarea') {
    $html_tag = 'textarea';
    $args{text_node} = $self->result if $has_result;
    $args{close_tag} = 1 unless defined $args{close_tag};
  }
  if ($self->syform->with_id and !defined $args{id}) {
    $args{id} = $args{name};
  }
  $html_tag = $args{html_tag} if defined $args{html_tag};
  return [ $html_tag, { %args } ];
}

has render => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_render {
  my ( $self ) = @_;
  my $html = "";
  my $it = natatime 2, @{$self->html_inputs};
  while (my ( $html_tag, $html_args ) = $it->()) {
    my $close_tag = defined $html_args->{close_tag}
      ? delete $html_args->{close_tag} : 0;
    my $text_node;
    if ($close_tag) {
      $text_node = defined $html_args->{text_node}
        ? delete $html_args->{text_node} : "";
    }
    $html .= '<'.$html_tag;
    my @html_keys = keys %{$html_args};
    if (scalar @html_keys) {
      my @attributes;
      for my $key (sort { $a cmp $b } @html_keys) {
        my $value = $html_args->{$key};
        push @attributes, $key.'="'.$value.'"';
      }
      $html .= " ".join(" ",@attributes);
    }
    $html .= '>';
    if ($close_tag) {
      $html .= $text_node;
      $html .= '</'.$html_tag.'>';
    }
    $html .= "\n";
  }
  return $html;
}

1;
