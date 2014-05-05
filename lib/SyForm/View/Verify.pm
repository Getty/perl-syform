package SyForm::View::Verify;
# ABSTRACT: Trait for SyForm fields of SyForm::Results and SyForm::Values attributes

use Moose::Role;
use namespace::clean;

has error_count => (
  is => 'ro',
  isa => 'Int',
  lazy_build => 1,
);

sub _build_error_count {
  my ( $self ) = @_;
  $self->results->error_count;
}

1;