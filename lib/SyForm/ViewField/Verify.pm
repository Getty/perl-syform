package SyForm::ViewField::Verify;
# ABSTRACT: Trait for SyForm fields of SyForm::Results and SyForm::Values attributes

use Moose::Role;
use namespace::clean;

sub is_invalid {
  my ( $self ) = @_;
  return $self->is_valid ? 0 : 1;
}

has is_valid => (
  is => 'ro',
  isa => 'Int',
  lazy_build => 1,
);

sub _build_is_valid {
  my ( $self ) = @_;
  return $self->results->validation_class->is_valid($self->name) ? 1 : 0;
}

has errors => (
  is => 'ro',
  isa => 'ArrayRef',
  lazy_build => 1,
);

sub _build_errors {
  my ( $self ) = @_;
  return [ $self->results->validation_class->get_errors($self->name) ];
}

# sub has_original_value {
#   my ( $self ) = @_;
#   return $self->has_value;
# }

# sub original_value {
#   my ( $self ) = @_;
#   return $self->results->verify_results->get_original_value($self->name);
# }

1;