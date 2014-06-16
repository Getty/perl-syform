package SyForm::Exception;
# ABSTRACT: SyForm base exception class

use Moo;
extends 'Throwable::Error';

around throw => sub {
  my ( $orig, $class, $message, %args ) = @_;
  $class->$orig({
    message => "\n".'[SyForm Exception] '.$message, %args
  });
};

sub throw_with_args {
  my ( $class, $message ) = @_;
  $class->throw($message);
}

1;