package SyForm::Results::Object;
# ABSTRACT: Functionality for SyForm::Results to deliver a Moose object

use Moose::Role;
use namespace::clean -except => 'meta';

around view_roles => sub {
  my ( $orig, $self, @args ) = @_;
  return [
    @{$self->$orig(@args)}, 'SyForm::View::Object'
  ];
};

has object => (
  is => 'ro',
  isa => 'Moose::Object',
  lazy_build => 1,
);

sub _build_object {
  my ( $self ) = @_;
  return $self->object_class->new($self->as_hashref);
}

has object_superclasses => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy => 1,
  default => sub {['Moose::Object']},
);

has object_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);
sub _build_object_class { $_[0]->object_metaclass->name }

has object_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy => 1,
  default => sub {[]},
);

has object_metaclass => (
  isa => 'Moose::Meta::Class',
  is => 'ro',
  lazy_build => 1,
);

sub _build_object_metaclass {
  my ( $self ) = @_;
  my @roles = @{$self->object_roles};
  return Moose::Meta::Class->create(
    (ref $self->syform).'::Object',
    superclasses => $self->object_superclasses,
    scalar @roles ? ( roles => $self->object_roles ) : (),
    attributes => [map {
      $self->get_field_meta_attribute($_);
    } @{$self->syform->process_fields}],
  );
}

sub get_field_meta_attribute {
  my ( $self, $field, %args ) = @_;
  return $self->meta_attributes_class->new($field->name,
    is => 'ro',
    predicate => $field->has_name,
    field => $field,
    results => $self,
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