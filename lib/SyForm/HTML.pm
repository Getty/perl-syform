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

has html_form_attributes => (
  is => 'ro',
  isa => 'HashRef[Str]',
  default => sub {{}},
);

has html_submit_attributes => (
  is => 'ro',
  isa => 'HashRef[Str]',
  default => sub {{}},
);

has html_submit_value => (
  is => 'ro',
  isa => 'Str',
  default => sub { 'Submit' },
);

has need_submit => (
  is => 'ro',
  isa => 'Bool',
  default => sub { 0 },
);

has method => (
  is => 'ro',
  isa => 'Str',
  default => sub { 'post' },
);

has action => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_action',
);

around view_roles => sub {
  my ( $orig, $self ) = @_;
  return [ @{$self->$orig}, 'SyForm::View::HTML' ];
};

1;
