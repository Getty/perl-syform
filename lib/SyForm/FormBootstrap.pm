package SyForm::FormBootstrap;
# ABSTRACT: Bootstrap Form

use Moo;
use HTML::Declare ':all';
use Safe::Isa;

with qw(
  MooX::Traits
);

our @attributes = qw();

for my $attribute (@attributes) {
  has $attribute => (
    is => 'ro',
    predicate => 1,
  );
}

has syform_formhtml => (
  is => 'ro',
  required => 1,
);

has layout => (
  is => 'lazy',
);

sub _build_layout {
  my ( $self ) = @_;
  return 'basic';
}

1;
