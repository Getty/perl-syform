package SyForm::ViewRole::HTML;
# ABSTRACT: HTML view functions

use Moo::Role;
use SyForm::FormHTML;

use overload '""' => sub { $_[0]->html };

has html => (
  is => 'lazy',
);

sub _build_html {
  my ( $self ) = @_;
  return $self->html_declare->as_html;
}

has html_declare => (
  is => 'lazy',
);

sub _build_html_declare {
  my ( $self ) = @_;
  return $self->syform_formhtml->html_declare;
}

has syform_formhtml => (
  is => 'lazy',
);

sub _build_syform_formhtml {
  my ( $self ) = @_;
  return SyForm::FormHTML->new(
    children => [
      map {
        $_->has_syform_formhtml_children ? (
          @{$_->syform_formhtml_children}
        ) : (),
      } $self->fields->Values
    ],
    no_submit => $self->syform->no_html_submit,
    $self->syform->has_html_submit ? (
      submit_attributes => $self->syform->html_submit,
    ) : (),
    $self->syform->has_html ? ( %{$self->syform->html} ) : ()
  );
}

1;