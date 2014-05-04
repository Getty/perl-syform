package SyForm::ViewField::Verify;
# ABSTRACT: Trait for SyForm fields of SyForm::Results and SyForm::Values attributes

use Moose::Role;
use namespace::autoclean;

sub is_invalid {
  my ( $self ) = @_;
  return $self->results->verify_results->is_invalid($self->name) ? 1 : 0;
}

sub is_valid {
  my ( $self ) = @_;
  return $self->results->verify_results->is_invalid($self->name) ? 0 : 1;
}

sub is_missing {
  my ( $self ) = @_;
  return $self->results->verify_results->is_missing($self->name) ? 1 : 0;
}

sub has_original_value {
  my ( $self ) = @_;
  return $self->has_value;
}

sub original_value {
  my ( $self ) = @_;
  return $self->results->verify_results->get_original_value($self->name);
}

1;