package SyForm::Field::Label;
# ABSTRACT: A label for the field

use Moose::Role;
use namespace::clean -except => 'meta';

has label => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_label',
);

around viewfield_roles_by_results => sub {
  my ( $orig, $self, $results ) = @_;
  return $self->$orig($results), qw( SyForm::ViewField::Label );
};

1;
