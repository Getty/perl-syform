package SyForm::Field::Verify;
# ABSTRACT: SyForm::Verify configuration of the field

use Moose::Role;
use namespace::clean -except => 'meta';

our @syccess_directives = qw(
  required
  is_number
  in
  length
  regex
);

for (@syccess_directives) {
  has $_ => (
    is => 'ro',
    predicate => 'has_'.$_,
  );
}

has no_delete_on_invalid_result => (
  is => 'ro',
  isa => 'Bool',
  default => sub { 0 },
);

around values_roles_by_process_args => sub {
  my ( $orig, $self, %args ) = @_;
  return $self->$orig(%args), qw(
    SyForm::Values::Verify
  );
};

around results_roles_by_values => sub {
  my ( $orig, $self, $values ) = @_;
  return $self->$orig($values), qw(
    SyForm::Results::Success
    SyForm::Results::Verify
  );
};

around view_roles_by_results => sub {
  my ( $orig, $self, $results ) = @_;
  return $self->$orig($results), qw( SyForm::View::Success );
};

1;
