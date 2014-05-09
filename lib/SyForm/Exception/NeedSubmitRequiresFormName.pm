package SyForm::Exception::NeedSubmitRequiresFormName;
# ABSTRACT:

use Moose;
extends 'SyForm::Exception';

with qw(
  SyForm::Exception::Role::WithSyForm
);

sub throw_with_args {
  my ( $class, $syform ) = @_;
  $class->throw('If need_submit is set, the form needs a name',
    syform => $syform,
  );
}

1;