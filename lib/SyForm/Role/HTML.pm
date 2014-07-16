package SyForm::Role::HTML;
# ABSTRACT: SyForm::ViewRole::HTML configuration of the form

use Moo::Role;

has submit_value => (
  is => 'ro',
  predicate => 1,
);

has no_submit => (
  is => 'lazy',
);

sub _build_no_submit {
  my ( $self ) = @_;
  return 0;
}

has target => (
  is => 'ro',
  predicate => 1,
);

has method => (
  is => 'ro',
  predicate => 1,
);

1;
