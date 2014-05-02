package SyForm::Exception::UnknownErrorOnBuildFields;

use Moose;
extends 'Throwable::Error';
use namespace::autoclean;

with qw(
  SyForm::Exception::Role::WithSyForm
);

around throw => sub {
  my ( $orig, $self, $syform, $error ) = @_;
  $self->$orig({
    message => '[ERROR] Unknown error on building up of fields'."\n\n".
      ' Original error message:'."\n\n".$error,
    syform => $syform,
  });
};

1;