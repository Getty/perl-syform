package SyForm::View::HTML;
# ABSTRACT:

use Moose::Role;
use HTML::Declare ':all';
use namespace::clean -except => 'meta';

around _build_viewfield_roles_for_all => sub {
  my ( $orig, $self ) = @_;
  return [ @{$self->$orig}, 'SyForm::ViewField::HTML' ];
};

has html_render => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_html_render {
  my ( $self ) = @_;
  my %attributes = %{$self->html_form_attributes};
  return FORM({
    %attributes,
    _ => [ $self->html_fields, $self->html_submit ],
  })->as_html;
}

has html_fields => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_html_fields {
  my ( $self ) = @_;
  my $html = '';
  for my $key ($self->syform->fields->Keys) {
    if (my $field = $self->fields->FETCH($key)) {
      $html .= $field->html_render;
    }
  }
  return $html;
}

has html_submit => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_html_submit {
  my ( $self ) = @_;
  return INPUT({
    %{$self->html_submit_attributes},
  })->as_html;
}

has html_submit_attributes => (
  is => 'ro',
  isa => 'HashRef',
  lazy_build => 1,
);

sub _build_html_submit_attributes {
  my ( $self ) = @_;
  my %attributes = %{$self->syform->html_submit_attributes};
  return {
    type => 'submit',
    value => $self->syform->html_submit_value,
    $self->syform->has_name ? (
      name => 'submit_'.$self->syform->name,
    ) : (),
    %attributes,
  };
}

has html_form_attributes => (
  is => 'ro',
  isa => 'HashRef',
  lazy_build => 1,
);

sub _build_html_form_attributes {
  my ( $self ) = @_;
  my %attributes = %{$self->syform->html_form_attributes};
  return {
    method => $self->syform->method,
    $self->syform->has_action ? ( action => $self->syform->action ) : (),
    %attributes,
  };
}

1;
