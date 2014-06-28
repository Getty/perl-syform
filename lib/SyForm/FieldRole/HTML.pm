package SyForm::FieldRole::HTML;
# ABSTRACT: SyForm::ViewFieldRole::HTML configuration of the field

use Moo::Role;

has html => (
  is => 'lazy',
);

sub _build_html {
  my ( $self ) = @_;
  return 'text';
}

1;
