package SyForm::ViewRole::Verify;
# ABSTRACT: Trait for SyForm fields of SyForm::Results and SyForm::Values attributes

use Moo::Role;

requires qw(
  success
);

has error_count => (
  is => 'lazy',
);

sub _build_error_count {
  my ( $self ) = @_;
  return $self->results->errors($self->name);
}

1;