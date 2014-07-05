package SyForm::FormBootstrap;
# ABSTRACT: Bootstrap Form

use Moo;
use HTML::Declare ':all';
use Safe::Isa;

with qw(
  MooX::Traits
);

our @attributes = qw();

for my $attribute (@attributes) {
  has $attribute => (
    is => 'ro',
    predicate => 1,
  );
}

has syform_formhtml => (
  is => 'ro',
  required => 1,
  handles => {
    form_html_attributes => 'html_attributes',
    no_submit => 'no_submit',

  },
);

has layout => (
  is => 'lazy',
);

sub _build_layout {
  my ( $self ) = @_;
  return 'basic';
}

has html_declare => (
  is => 'lazy',
);

sub _build_html_declare {
  my ( $self ) = @_;
  return FORM {
    %{$self->form_html_attributes},
    _ => [
      $self->no_submit ? () : ( $self->syform_formhtml->submit->html_declare ),
    ],
  };
}

1;
