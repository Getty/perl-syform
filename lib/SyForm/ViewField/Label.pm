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
  my %attributes = %{$self->label_attributes};
  my $html_tag = delete $attributes{html_tag};
  my $label = '<'.$html_tag;
  if (scalar keys %attributes) {
    my @attrs;
    for my $key (sort { $a cmp $b } keys %attributes) {
      my $value = $attributes{$key};
      push @attrs, $key.'="'.$value.'"';
    }
    $label .= " ".join(" ",@attrs);
  }
  $label .= '>'.($self->label).'</'.$html_tag.'>';
  return $label;
}

has label_attributes => (
  is => 'ro',
  isa => 'HashRef[Str]',
  lazy_build => 1,
);

sub _build_label_attributes {
  my ( $self ) = @_;
  return {
    for => $self->html_name,
    html_tag => 'label',
  };
}

1;
