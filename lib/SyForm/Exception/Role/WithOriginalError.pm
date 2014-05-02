package SyForm::Exception::Role::WithOriginalError;

use Moose::Role;

has original_error => (
  is => 'ro',
  required => 1,
);

sub rethrow_syform_exception {
  my ( $class, $error ) = @_;
  die $error if $error->isa('SyForm::Exception');
}

around throw => sub {
  my ( $orig, $class, $message, %args ) = @_;
  $message .= "\n".'[Original Error] '.$args{original_error};
  return $class->$orig($message, %args);
};

1;