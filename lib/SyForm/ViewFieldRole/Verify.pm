package SyForm::ViewFieldRole::Verify;
# ABSTRACT: Trait for SyForm fields of SyForm::Results and SyForm::Values attributes

use Moo::Role;

has is_invalid => (
  is => 'lazy',
);

sub _build_is_invalid {
  my ( $self ) = @_;
  return $self->is_valid ? 0 : 1;
}

has is_valid => (
  is => 'lazy',
);

sub _build_is_valid {
  my ( $self ) = @_;
  my @errors = @{$self->errors};
  return scalar @errors > 0 ? 0 : 1;
}

has errors => (
  is => 'lazy',
);

sub _build_errors {
  my ( $self ) = @_;
  return $self->results->does('SyForm::ResultsRole::Success')
    ? $self->results->syccess_result->errors($self->name) : [];
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