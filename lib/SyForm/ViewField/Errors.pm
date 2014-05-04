package SyForm::ViewField::Errors;
# ABSTRACT: Errors on the field

use Moose::Role;
use namespace::autoclean;

has errors => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  lazy_build => 1,
);

sub _build_errors {
  my ( $self ) = @_;
  [];
}

1;