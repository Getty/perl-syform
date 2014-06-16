package SyForm::Role::Verify;
# ABSTRACT: Main verification logic (role for form holding config)

use Moo::Role;
use Module::Runtime qw( use_module );

has verify_without_errors => (
  is => 'lazy',
);

sub _build_verify_without_errors {
  my ( $self ) = @_;
  return 0;
}

has syccess => (
  is => 'lazy',
);

sub _build_syccess {
  my ( $self ) = @_;
  return {};
}

has syccess_class => (
  is => 'lazy',
);

sub _build_syccess_class {
  my ( $self ) = @_;
  return 'Syccess';
}

has loaded_syccess_class => (
  is => 'lazy',
);

sub _build_loaded_syccess_class {
  my ( $self ) = @_;
  return use_module($self->syccess_class);
}

1;