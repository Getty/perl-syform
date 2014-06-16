package SyForm::Exception::UnknownArgOnCreateValuesByArgs;
# ABSTRACT: Unknown arg on SyForm::Process->create_values_by_args

use Moo;
extends 'SyForm::Exception';

with qw(
  SyForm::Exception::Role::WithSyForm
);

has arg => (
  is => 'ro',
  required => 1,
);

sub throw_with_args {
  my ( $class, $syform, $arg ) = @_;
  my $ref = ref $arg;
  $class->throw('Unknown arg of ref "'.$ref.'" on create_values_by_args',
    syform => $syform,
    arg => $arg,
  );
};

1;