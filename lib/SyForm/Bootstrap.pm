package SyForm::Bootstrap;
# ABSTRACT: Bootstrap support for your SyForm::View

use Moose::Role;
use namespace::clean -except => 'meta';

with qw(
  SyForm::HTML
);

has bootstrap_form => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_bootstrap_form',
);

has bootstrap_submit_size => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_bootstrap_submit_size',
);

has bootstrap_submit_option => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_bootstrap_submit_option {
  my ( $self ) = @_;
  return 'default';
}

around _build_view_roles => sub {
  my ( $orig, $self ) = @_;
  return [ @{$self->$orig}, 'SyForm::View::Bootstrap' ];
};

1;