package SyForm::CommonRole::GlobalHTML;
# ABSTRACT: Standard role for objects with HTML global attributes

use Moo::Role;

our @attributes = qw(
  class
  accesskey
  contenteditable
  contextmenu
  dir
  draggable
  dropzone
  hidden
  lang
  spellcheck
  style
  tabindex
  title
  translate
  id
  name
);

for my $attribute (@attributes) {
  has $attribute => (
    is => 'ro',
    predicate => 1,
  );
}

has data => (
  is => 'ro',
  predicate => 1,
);

has data_attributes => (
  is => 'lazy',
  init_arg => undef,
);

sub _build_data_attributes {
  my ( $self ) = @_;
  return {} unless $self->has_data;
  my %data_attributes;
  for my $key (sort { $a cmp $b } keys %{$self->data}) {
    my $value = $self->data->{$key};
    $key =~ s/_/-/g;
    $data_attributes{'data-'.$key} = $value;
  }
  return { %data_attributes };
}

1;
