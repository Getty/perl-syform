package SyForm::Results::Verify;
# ABSTRACT: Trait for SyForm fields of SyForm::Results and SyForm::Values attributes

use Moose::Role;
use namespace::clean -except => 'meta';

with qw(
  SyForm::Results::Success
);

has syccess_result => (
  is => 'ro',
  isa => 'Syccess::Result',
  required => 1,
);

has error_count => (
  is => 'ro',
  isa => 'Int',
  lazy_build => 1,
);

sub _build_error_count {
  my ( $self ) = @_;
  $self->syccess_result->error_count;
}

1;