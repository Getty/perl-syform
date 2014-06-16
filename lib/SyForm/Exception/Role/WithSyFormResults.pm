package SyForm::Exception::Role::WithSyFormResults;
# ABSTRACT: Role for exceptions with a SyForm::Results

use Moo::Role;

has results => (
  is => 'ro',
  required => 1,
  handles => [qw(
    syform
  )],
);

1;