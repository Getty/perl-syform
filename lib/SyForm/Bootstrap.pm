package SyForm::Bootstrap;
# ABSTRACT: Bootstrap support for your SyForm::View

use Moose::Role;
use namespace::clean -except => 'meta';

around _build_view_roles => sub {
  my ( $orig, $self ) = @_;
  return [ @{$self->$orig}, 'SyForm::View::Bootstrap' ];
};

1;