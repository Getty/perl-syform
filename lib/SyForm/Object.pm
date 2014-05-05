package SyForm::Object;
# ABSTRACT: Adding SyForm::Values::Object to values_roles

use Moose::Role;
use namespace::clean -except => 'meta';

around values_roles => sub {
  my ( $orig, $self, @args ) = @_;
  return [
    @{$self->$orig(@args)}, 'SyForm::Values::Object'
  ];
};

1;