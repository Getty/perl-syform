package SyForm::HTML;
# ABSTRACT:

use Moose::Role;
use namespace::clean -except => 'meta';

has html_attributes => (
  is => 'ro',
  isa => 'HashRef[Str]',
  default => sub {{}},
);

has html_input_attributes => (
  is => 'ro',
  isa => 'HashRef[Str]',
  default => sub {{}},
);

has submit_attributes => (
  is => 'ro',
  isa => 'HashRef[Str]',
  default => sub {{}},
);

has submit_html_tag => (
  is => 'ro',
  isa => 'Str',
  default => sub { 'input' },
);

has method => (
  is => 'ro',
  isa => 'Str',
  default => sub { 'POST' },
);

has with_id => (
  is => 'ro',
  isa => 'Bool',
  default => sub { 1 },
);

around view_roles => sub {
  my ( $orig, $self ) = @_;
  return [ @{$self->$orig}, 'SyForm::View::HTML' ];
};

1;
