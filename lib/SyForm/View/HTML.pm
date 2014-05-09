package SyForm::View::HTML;
# ABSTRACT:

use Moose::Role;
use namespace::clean -except => 'meta';

has render => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_render {
  my ( $self ) = @_;
  my $html = '<form>'."\n";
  for my $key ($self->syform->fields->Keys) {
    if (defined $self->fields->{$key}) {
      $html .= $self->fields->{$key}->render;
    }
  }
  $html .= '</form>';
  return $html;
}

1;
