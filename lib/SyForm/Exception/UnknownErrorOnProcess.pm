package SyForm::Exception::UnknownErrorOnProcess;

use Moose;
extends 'Throwable::Error';
use namespace::autoclean;

with qw(
  SyForm::Exception::Role::WithSyForm
  SyForm::Exception::Role::WithOriginalError
);

has process_args => (
  is => 'ro',
  isa => 'ArrayRef',
  required => 1,
);

around throw => sub {
  my ( $orig, $self, $syform, $process_args, $error ) = @_;
  $self->$orig({
    message => '[ERROR] Unknown error on process of SyForm'."\n\n".
      ' Original error message:'."\n\n".$error,
    syform => $syform,
    original_error => $error,
    process_args => $process_args,
  });
};

1;