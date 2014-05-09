package SyForm::HTML;
# ABSTRACT:

use Moose::Role;
use namespace::clean -except => 'meta';

around view_roles => sub {
  my ( $orig, $self ) = @_;
  return [ @{$self->$orig}, 'SyForm::View::HTML' ];
};

1;
