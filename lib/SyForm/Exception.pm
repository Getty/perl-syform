package SyForm::Exception;
# ABSTRACT: SyForm base exception class

use Moose;
extends 'Throwable::Error';

around throw => sub {
  my ( $orig, $class, $message, %args ) = @_;
  $class->$orig({
    message => '[SyForm Exception] '.$message, %args
  });
};

sub throw_with_args {
  my ( $class, $message ) = @_;
  $class->throw($message);
}

1;