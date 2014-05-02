package SyForm::Exception::UnexpectedCallToGetValueByArgs;

use Moose;
extends 'Throwable::Error';
use namespace::autoclean;

with qw(
  SyForm::Exception::Role::WithSyFormField
);

around throw => sub {
  my ( $orig, $self, $field ) = @_;
  $self->$orig({
    message => '[ERROR] Unexpected call to get_value_by_args on the field "'.$field->name.'".'."\n\n".
      ' There must be a call to has_value_by_args before using this function, to assure there exist a value.',
    field => $field,
  });
};

1;