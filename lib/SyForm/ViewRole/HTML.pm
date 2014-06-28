package SyForm::ViewRole::HTML;
# ABSTRACT: HTML view functions

use Moo::Role;
use HTML::Declare ':all';

use overload '""' => sub { $_[0]->html };

has html => (
  is => 'lazy',
);

sub _build_html {
  my ( $self ) = @_;

}

1;