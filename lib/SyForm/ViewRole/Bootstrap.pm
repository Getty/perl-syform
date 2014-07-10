package SyForm::ViewRole::Bootstrap;
# ABSTRACT: Bootstrap view functions

use Moo::Role;

has bootstrap_layout => (
  is => 'lazy',
);

sub _build_bootstrap_layout {
  my ( $self ) = @_;
  return $self->syform->bootstrap->{layout}
    if $self->syform->has_bootstrap && $self->syform->bootstrap->{layout};
  return 'basic';
}

1;