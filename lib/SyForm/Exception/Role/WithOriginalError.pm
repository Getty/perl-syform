package SyForm::Exception::Role::WithOriginalError;
# ABSTRACT: Role for exceptions with a non SyForm error

use Moose::Role;

has original_error => (
  is => 'ro',
  required => 1,
);

sub rethrow_syform_exception {
  my ( $class, $error ) = @_;
  die $error if $error->isa('SyForm::Exception');
}

sub error_message_text {
  my ( $class, $error ) = @_;
  my $error_type = $error->isa('Moose::Exception')
    ? 'Moose exception' : 'Unknown error';
}

around throw => sub {
  my ( $orig, $class, $message, %args ) = @_;
  $message .= "\n".'[Original Error] '.$args{original_error};
  return $class->$orig($message, %args);
};

1;