package SyForm::FieldRole::HTML;
# ABSTRACT: SyForm::ViewFieldRole::HTML configuration of the field

use Moo::Role;
use SyForm::Field::InputHTML;

has input => (
  is => 'lazy',
  init_arg => undef,
);

has input_args => (
  is => 'ro',
  init_arg => 'input',
  predicate => 1,
);

sub _build_input {
  my ( $self ) = @_;
  return SyForm::Field::InputHTML->new(
    type => 'text',
    $self->has_input_args ? ( %{$self->input_args} ) : ()
  );
}

1;
