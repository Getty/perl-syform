package SyForm::View::Bootstrap;

use Moo;

with qw(
  SyForm::ViewRole
  SyForm::ViewRole::Success
  SyForm::ViewRole::Verify
);

has bootstrap_layout => (
  is => 'lazy',
);

sub _build_bootstrap_layout {
  my ( $self ) = @_;
  return $self->syform->bootstrap->{layout}
    if $self->syform->has_bootstrap && $self->syform->bootstrap->{layout};
  return 'basic';
}

has bootstrap_submit_value => (
  is => 'lazy',
);

sub _build_bootstrap_submit_value {
  my ( $self ) = @_;
  return $self->syform->bootstrap_submit->{value}
    if $self->syform->has_bootstrap_submit
      && $self->syform->bootstrap_submit->{value};
  return 'Submit';
}

has bootstrap_submit_style => (
  is => 'lazy',
);

sub _build_bootstrap_submit_style {
  my ( $self ) = @_;
  return $self->syform->bootstrap_submit->{style}
    if $self->syform->has_bootstrap_submit
      && $self->syform->bootstrap_submit->{style};
  return 'default';
}

has bootstrap_submit_size => (
  is => 'lazy',
);

sub _build_bootstrap_submit_size {
  my ( $self ) = @_;
  return $self->syform->bootstrap_submit->{size}
    if $self->syform->has_bootstrap_submit
      && $self->syform->bootstrap_submit->{size};
  return undef;
}

has bootstrap_submit_block => (
  is => 'lazy',
);

sub _build_bootstrap_submit_block {
  my ( $self ) = @_;
  return $self->syform->bootstrap_submit->{block} ? 1 : 0
    if $self->syform->has_bootstrap_submit
      && $self->syform->bootstrap_submit->{block};
  return 0;
}

has bootstrap_submit_active => (
  is => 'lazy',
);

sub _build_bootstrap_submit_active {
  my ( $self ) = @_;
  return $self->syform->bootstrap_submit->{active} ? 1 : 0
    if $self->syform->has_bootstrap_submit
      && $self->syform->bootstrap_submit->{active};
  return 0;
}

has bootstrap_submit_class => (
  is => 'lazy',
);

sub _build_bootstrap_submit_class {
  my ( $self ) = @_;
  return $self->syform->bootstrap_submit->{class}
    if $self->syform->has_bootstrap_submit
      && $self->syform->bootstrap_submit->{class};
  return undef;
}

has bootstrap_submit_attributes => (
  is => 'lazy',
);

sub _build_bootstrap_submit_attributes {
  my ( $self ) = @_;
  my @classes = ( 'btn', 'btn-'.$self->bootstrap_submit_style );
  push @classes, 'btn-'.$self->bootstrap_submit_size if $self->bootstrap_submit_size;
  push @classes, 'btn-block' if $self->bootstrap_submit_block;
  push @classes, $self->bootstrap_submit_class if $self->bootstrap_submit_class;
  push @classes, 'active' if $self->bootstrap_submit_active;
  return {
    $self->syform->has_name ? ( name => $self->syform->name ) : (),
    class => join(' ',@classes),
    role => 'button',
    value => $self->bootstrap_submit_value,
    $self->syform->has_bootstrap_submit_attributes
      ? ( %{$self->syform->bootstrap_submit_attributes} ) : (),
  };
}

1;
