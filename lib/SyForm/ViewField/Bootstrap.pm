package SyForm::ViewField::Bootstrap;
# ABSTRACT: SyForm::ViewField role for Bootstrap support

use Moose::Role;
use namespace::clean -except => 'meta';

# workaround to be sure to be around label rendering, must add more
# sorting of the roles... hmpf....
around render => sub {
  my ( $orig, $self ) = @_;
  my $html = '<div class="form-group">'."\n";
  $html .= '  '.$self->$orig;
  $html .= '</div>'."\n";
  return $html;
};

1;