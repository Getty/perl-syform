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

has input_attrs => (
  is => 'rw',
  isa => 'ArrayRef[Str|HashRef[Str]]',
  lazy_build => 1,
);

sub _build_input_attrs {
  my ( $self ) = @_;
  my $html_tag;
  my $html = $self->html;
  my %custom_args = %{$self->field->custom_input_attrs};
  $html = delete $custom_args{html} if defined $custom_args{html};
  $custom_args{name} = $self->html_name
    unless defined $custom_args{name};
  my $has_result = $self->has_result;
  if ($html eq 'text') {
    $html_tag = 'input';
    if ($has_result) {
      $custom_args{value} = $self->result;
    }
    $custom_args{type} = 'text' unless defined $custom_args{type};
  } elsif ($html eq 'hidden') {
    $html_tag = 'input';
    if ($has_result) {
      $custom_args{value} = $self->result;
    }
    $custom_args{type} = 'hidden' unless defined $custom_args{type};
  } elsif ($html eq 'textarea') {
    $html_tag = 'textarea';
    if ($has_result) {
      $custom_args{text_node} = $self->result;
    }
    $custom_args{close_tag} = 1 unless defined $custom_args{close_tag};
  }
  $html_tag = $custom_args{html_tag} if defined $custom_args{html_tag};
  return [ $html_tag, { %custom_args } ];
}

sub render {
  my ( $self ) = @_;
  my $html = "";
  my $it = natatime 2, @{$self->input_attrs};
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
