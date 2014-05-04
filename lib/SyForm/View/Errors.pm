package SyForm::View::Errors;
# ABSTRACT: Errors on the form itself

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