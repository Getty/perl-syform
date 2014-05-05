package SyForm::Object;
# ABSTRACT: Adding SyForm::Values::Object to values_roles

use Moose::Role;
use namespace::clean -except => 'meta';

around _build_values_roles => sub {
  my ( $orig, $self ) = @_;
  return [ @{$self->$orig}, 'SyForm::Values::Object' ];
};

around _build_results_roles => sub {
  my ( $orig, $self ) = @_;
  return [ @{$self->$orig}, 'SyForm::Results::Object' ];
};

around _build_view_roles => sub {
  my ( $orig, $self ) = @_;
  return [ @{$self->$orig}, 'SyForm::View::Object' ];
};

has fields_object_superclasses => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy => 1,
  default => sub {[$_[0]->object_class]},
);

has fields_object_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);
sub _build_fields_object_class { $_[0]->fields_object_metaclass->name }

has fields_object_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy => 1,
  default => sub {[]},
);

has fields_object_metaclass => (
  isa => 'Moose::Meta::Class',
  is => 'ro',
  lazy_build => 1,
);

sub _build_fields_object_metaclass {
  my ( $self ) = @_;
  my @roles = @{$self->fields_object_roles};
  return Moose::Meta::Class->create(
    (ref $self).'::Object',
    superclasses => $self->fields_object_superclasses,
    scalar @roles ? ( roles => [ @roles ] ) : (),
    attributes => [map {
      $self->get_field_meta_attribute($_);
    } @{$self->process_fields}],
  );
}

sub get_field_meta_attribute {
  my ( $self, $field, %args ) = @_;
  return $self->meta_attributes_class->new($field->name,
    is => 'ro',
    predicate => $field->has_name,
    field => $field,
    %args,
  );
}

has meta_attributes_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_meta_attributes_class {
  my ( $self ) = @_;
  return $self->meta_attributes_metaclass->name;
}

has meta_attributes_metaclass => (
  isa => 'Moose::Meta::Class',
  is => 'ro',
  lazy_build => 1,
);

sub _build_meta_attributes_metaclass {
  my ( $self ) = @_;
  return Moose::Meta::Class->create_anon_class(
    superclasses => ['Moose::Meta::Attribute'],
    roles => [
      'SyForm::Meta::Attribute::Field',
      @{$self->meta_attributes_metaclass_roles},
    ],
  )
}

has meta_attributes_metaclass_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy => 1,
  default => sub {[]},
);

1;