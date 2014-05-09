package SyForm::Bootstrap;
# ABSTRACT: Bootstrap support for your SyForm::View

use Moose::Role;
use namespace::clean -except => 'meta';

has bootstrap_form => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_bootstrap_form',
);

around _build_view_roles => sub {
  my ( $orig, $self ) = @_;
  return [ @{$self->$orig}, 'SyForm::View::Bootstrap' ];
};

1;