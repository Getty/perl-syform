package SyForm::ViewField::Bootstrap;
# ABSTRACT: SyForm::ViewField role for Bootstrap support

use Moose::Role;
use HTML::Declare ':all';
use namespace::clean -except => 'meta';

has bootstrap_render => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_bootstrap_render {
  my ( $self ) = @_;
  return DIV({
    class => 'form-group',
    _ => [ "\n", $self->html_label, "\n", $self->html_input ],
  })->as_html;
}

1;