package SyForm::Field::Verify;
# ABSTRACT: Required field

use Moose::Role;
use namespace::clean;

our @validation_class_directives = qw(
  required
  between
  date
  decimal
  depends_on
  email
  error
  hostname
  length
  matches
  time
  options
  pattern
  messages
  filters
  readonly
  max_alpha
  max_digits
  max_length
  max_sum
  max_symbols
  min_alpha
  min_digits
  min_length
  min_sum
  min_symbols
);

for (@validation_class_directives) {
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

around viewfield_roles_by_results => sub {
  my ( $orig, $self, $results ) = @_;
  return $self->$orig($results), qw( SyForm::ViewField::Verify );
};

around view_roles_by_results => sub {
  my ( $orig, $self, $results ) = @_;
  return $self->$orig($results), qw( SyForm::View::Success );
};

1;
