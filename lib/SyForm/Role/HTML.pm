package SyForm::Role::HTML;
# ABSTRACT: SyForm::ViewRole::HTML configuration of the form

use Moo::Role;

has html => (
  is => 'ro',
  predicate => 1,
);

has html_submit => (
  is => 'ro',
  predicate => 1,
);

has no_html_submit => (
  is => 'lazy',
);

sub _build_no_html_submit {
  my ( $self ) = @_;
  return 0;
}

1;
