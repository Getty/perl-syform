package SyForm::ViewRole::Bootstrap;
# ABSTRACT: Bootstrap view functions

use Moo::Role;
use SyForm::FormBootstrap;

use overload '""' => sub { $_[0]->html_bootstrap };

has html_bootstrap => (
  is => 'lazy',
);

sub _build_html_bootstrap {
  my ( $self ) = @_;
  return $self->html_declare_bootstrap->as_html;
}

has html_declare_bootstrap => (
  is => 'lazy',
);

sub _build_html_declare_bootstrap {
  my ( $self ) = @_;
  return $self->syform_formbootstrap->html_declare;
}

has syform_formbootstrap => (
  is => 'lazy',
);

sub _build_syform_formbootstrap {
  my ( $self ) = @_;
  return SyForm::FormBootstrap->new(
    children => [
      map {
        $_->has_syform_formbootstrap_children ? (
          @{$_->syform_formbootstrap_children}
        ) : (),
      } $self->fields->Values
    ],
    syform_formhtml => $self->syform_formhtml,
    $self->syform->has_bootstrap ? ( %{$self->syform->bootstrap} ) : (),
  );
}

1;