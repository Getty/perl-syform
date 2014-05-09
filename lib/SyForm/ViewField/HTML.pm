package SyForm::ViewField::HTML;
# ABSTRACT: HTML viewfield of a HTML field

use Moose::Role;
use List::MoreUtils qw( natatime );
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

has html_input_attributes => (
  is => 'ro',
  isa => 'HashRef',
  lazy_build => 1,
);

sub _build_html_input_attributes {
  my ( $self ) = @_;
  return $self->field->html_attributes;
}

has html_input_fields => (
  is => 'ro',
  isa => 'ArrayRef[Str|HashRef[Str]]',
  lazy_build => 1,
);

sub _build_html_input_fields {
  my ( $self ) = @_;
  my $html_tag;
  my $html = $self->html;
  my %args = %{$self->html_input_attributes};
  $html = delete $args{html} if defined $args{html};
  $args{name} = $self->html_name
    unless defined $args{name};
  my $has_result = $self->has_result;
  if ($html eq 'text') {
    $html_tag = 'input';
    $args{value} = $self->result if $has_result;
    $args{type} = 'text' unless defined $args{type};
  } elsif ($html eq 'password') {
    $html_tag = 'input';
    $args{type} = 'password' unless defined $args{type};
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

has html_input => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_html_input {
  my ( $self ) = @_;
  return join("\n",@{$self->html_inputs});
}

has html_inputs => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  lazy_build => 1,
);

sub _build_html_inputs {
  my ( $self ) = @_;
  my @html_inputs;
  my $it = natatime 2, @{$self->html_input_fields};
  while (my ( $html_tag, $html_args ) = $it->()) {
    my $html = "";
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
    push @html_inputs, $html;
  }
  return [ @html_inputs ];
}

has render => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_render {
  my ( $self ) = @_;
  if ($self->does('SyForm::ViewField::Label')) {
    return ($self->html_label).($self->html_input);
  }
  return $self->html_input;
}

1;
