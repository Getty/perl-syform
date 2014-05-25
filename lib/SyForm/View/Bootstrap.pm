package SyForm::View::Bootstrap;
# ABSTRACT: SyForm::View role for Bootstrap support

use Moose::Role;
use HTML::Declare ':all';
use namespace::clean -except => 'meta';

around _build_viewfield_roles_for_all => sub {
  my ( $orig, $self ) = @_;
  return [ @{$self->$orig}, 'SyForm::ViewField::Bootstrap' ];
};

has bootstrap_fields => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_bootstrap_fields {
  my ( $self ) = @_;
  my $html = '';
  for my $key ($self->syform->fields->Keys) {
    if (my $field = $self->fields->FETCH($key)) {
      $html .= $field->bootstrap_render."\n";
    }
  }
  return $html;
}

has bootstrap_submit => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_bootstrap_submit {
  my ( $self ) = @_;
  return INPUT({
    %{$self->html_submit_attributes},
    type => "submit",
    class => "btn btn-default",
  })->as_html;
}

has bootstrap_render => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_bootstrap_render {
  my ( $self ) = @_;
  my %attributes = %{$self->html_form_attributes};
  $attributes{role} = 'form' unless defined $attributes{role};
  return FORM({
    %attributes,
    _ => [ "\n", $self->bootstrap_fields, $self->bootstrap_submit, "\n" ],
  })->as_html;
}

1;