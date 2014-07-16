package SyForm::ViewFieldRole::Bootstrap;
# ABSTRACT: 

use Moo::Role;

has bootstrap_type => (
  is => 'lazy',
);

sub _build_bootstrap_type {
  my ( $self ) = @_;
  return $self->field->bootstrap->{type} if $self->field->has_bootstrap
    && $self->field->bootstrap->{type};
  return 'text';
}

has bootstrap_input_attributes => (
  is => 'lazy',
);

sub _build_bootstrap_input_attributes {
  my ( $self ) = @_;
  my %attr = %{$self->input_attributes};
  my %battr = $self->field->has_bootstrap_input_attributes ? (
    %{$self->field->bootstrap_input_attributes}
  ) : ();
  my @class = defined $attr{class}
    ? ( split(/\s+/,delete $attr{class}) ) || ();
  push @class, defined $battr{class}
    ? ( split(/\s+/,delete $battr{class}) ) || ();
  unshift @class, 'form-control';
  return {
    class => join(" ",@class),
    %attr,
    %battr,
  };
}

has bootstrap_formgroup_attributes => (
  is => 'lazy',
);

sub _build_bootstrap_formgroup_attributes {
  my ( $self ) = @_;
  my %attr = $self->field->has_bootstrap_formgroup_attributes ? (
    %{$self->field->bootstrap_formgroup_attributes}
  ) : ();
  my @class = defined $attr{class}
    ? ( split(/\s+/,delete $attr{class}) ) || ();
  unshift @class, 'form-group';
  return {
    class => join(" ",@class),
    %attr,
  };
}

1;