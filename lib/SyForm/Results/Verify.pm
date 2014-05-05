package SyForm::Results::Verify;
# ABSTRACT: Trait for SyForm fields of SyForm::Results and SyForm::Values attributes

use Moose::Role;
use namespace::clean -except => 'meta';

has validation_class => (
  is => 'ro',
  isa => 'Validation::Class::Simple',
  required => 1,
);

has error_count => (
  is => 'ro',
  isa => 'Int',
  lazy_build => 1,
);

sub _build_error_count {
  my ( $self ) = @_;
  $self->validation_class->error_count;
}

1;