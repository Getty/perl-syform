package SyForm::View::Bootstrap;
# ABSTRACT: SyForm::View role for Bootstrap support

use Moose::Role;
use namespace::clean -except => 'meta';

around _build_viewfield_roles_for_all => sub {
  my ( $orig, $self ) = @_;
  return [ @{$self->$orig}, 'SyForm::ViewField::Bootstrap' ];
};

around _build_html_attributes => sub {
  my ( $orig, $self ) = @_;
  my %html_attributes = %{$self->$orig};
  if ($self->syform->has_bootstrap_form) {
    if ($self->syform->bootstrap_form eq 'horizontal') {
      if (defined $html_attributes{class}) {
        $html_attributes{class} .= ' form-horizontal';
      } else {
        $html_attributes{class} = 'form-horizontal';
      }
    }
  }
  $html_attributes{role} = 'form' unless defined $html_attributes{role};
  return { %html_attributes };
};

1;