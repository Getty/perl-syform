package SyForm::FieldRole;
# ABSTRACT: Role for fields in SyForm

use Moo::Role;

with qw(
  MooX::Traits
  SyForm::FieldRole::Process
);

has syform => (
  is => 'ro',
  weak_ref => 1,
  required => 1,
);

has name => (
  is => 'ro',
  required => 1,
);

has has_name => (
  is => 'lazy',
);
sub _build_has_name { return 'has_'.($_[0]->name) }

has label => (
  is => 'lazy',
);

sub _build_label {
  my ( $self ) = @_;
  my $name = $self->name;
  $name =~ s/_/ /g;
  return join(' ', map { ucfirst($_) } split(/\s+/,$name) );
}

1;
