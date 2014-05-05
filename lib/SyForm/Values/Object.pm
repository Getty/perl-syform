package SyForm::Values::Object;
# ABSTRACT: Adding SyForm::Results::Object to results_roles

use Moose::Role;
use namespace::clean -except => 'meta';

around results_roles => sub {
  my ( $orig, $self, @args ) = @_;
  return [
    @{$self->$orig(@args)}, 'SyForm::Results::Object'
  ];
};

1;