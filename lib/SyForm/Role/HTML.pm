package SyForm::Role::HTML;
# ABSTRACT: SyForm::View::HTML configuration of the form

use Moo::Role;
use SyForm::FormHTML;

has html => (
  is => 'lazy',
  init_arg => undef,
);

has html_args => (
  is => 'ro',
  init_arg => 'html',
  predicate => 1,
);

sub _build_html {
  my ( $self ) = @_;
  return SyForm::FormHTML->new(
    $self->has_html_args ? ( %{$self->html_args} ) : ()
  );
}

1;
