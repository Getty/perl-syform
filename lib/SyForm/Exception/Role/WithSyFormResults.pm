package SyForm::Exception::Role::WithSyFormResults;
# ABSTRACT: Role for exceptions with a SyForm::Results

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