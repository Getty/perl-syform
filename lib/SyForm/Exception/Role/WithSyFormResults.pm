package SyForm::Exception::Role::WithSyFormResults;

use Moose::Role;

has results => (
  is => 'ro',
  does => 'SyForm::Results',
  required => 1,
  handles => [qw(
    syform
  )],
);

1;