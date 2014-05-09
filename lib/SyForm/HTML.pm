package SyForm::HTML;
# ABSTRACT:

use Moose::Role;
use namespace::clean -except => 'meta';

has custom_html_attributes => (
  is => 'rw',
  isa => 'HashRef[Str]',
  default => sub {{}},
);

has method => (
  is => 'rw',
  isa => 'Str',
  default => sub { 'POST' },
);

has with_id => (
  is => 'rw',
  isa => 'Bool',
  default => sub { 1 },
);

around view_roles => sub {
  my ( $orig, $self ) = @_;
  return [ @{$self->$orig}, 'SyForm::View::HTML' ];
};

1;
