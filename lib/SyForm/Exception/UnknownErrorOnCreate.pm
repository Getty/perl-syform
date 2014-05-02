package SyForm::Exception::UnknownErrorOnCreate;

use Moose;
extends 'Throwable::Error';
use namespace::autoclean;

with qw(
  SyForm::Exception::Role::WithOriginalError
);

has create_args => (
  is => 'ro',
  isa => 'ArrayRef',
  required => 1,
);

around throw => sub {
  my ( $orig, $self, $create_args, $error ) = @_;
  $self->$orig({
    message => '[ERROR] Unknown error on create of SyForm'."\n\n".
      ' Original error message:'."\n\n".$error,
    create_args => $create_args,
    original_error => $error,
  });
};

1;