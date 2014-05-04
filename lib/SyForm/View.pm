package SyForm::View;

use Moose::Role;
use namespace::autoclean;

with qw(
  MooseX::Traits
);

has results => (
  is => 'ro',
  does => 'SyForm::Results',
  required => 1,
  handles => [qw(
    syform
  )],
);

#############
#
# View Field
#
#############

has viewfield_roles => (
  isa => 'HashRef[Str|ArrayRef[Str]]',
  is => 'ro',
  lazy => 1,
  default => sub {{}},
);

has viewfield_role => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_viewfield_role { 'SyForm::ViewField' }

has viewfield_object_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);
sub _build_viewfield_object_class { $_[0]->syform->object_class }

has viewfield_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_viewfield_class {
  my ( $self ) = @_;
  return $self->_viewfield_metaclass->name;
}

has _viewfield_metaclass => (
  isa => 'Moose::Meta::Class',
  is => 'ro',
  lazy_build => 1,
);

sub _build__viewfield_metaclass {
  my ( $self ) = @_;
  my $syform = $self->syform;
  return Moose::Meta::Class->create(
    (ref $syform).'::ViewField',
    superclasses => [$self->viewfield_object_class],
    roles => [ $self->viewfield_role ],
  )
}

has field_names => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  lazy_build => 1,
);

sub _build_field_names {
  my ( $self ) = @_;
  [map { $_->name } @{$self->fields}];
}

has fields => (
  is => 'ro',
  isa => 'HashRef[SyForm::ViewField]',
  lazy_build => 1,
);
sub field { shift->fields->{(shift)} }
sub viewfield { shift->fields->{(shift)} }

sub _build_fields {
  my ( $self ) = @_;
  my %viewfield_roles = %{$self->viewfield_roles};
  my %fields;
  for my $field ($self->syform->fields->Values) {
    my %viewfield_args = $field->viewfield_args_by_results($self->results);
    my @traits = defined $viewfield_roles{$field->name}
      ? (@{$viewfield_roles{$field->name}}) : ();
    push @traits, @{delete $viewfield_args{roles}}
        if defined $viewfield_args{roles};
    $fields{$field->name} = $self->create_viewfield($field,
      field => $field,
      roles => [ @traits ],
    );
  }
  return { %fields };
}

sub create_viewfield {
  my ( $self, $field, %args ) = @_;
  my @traits = @{delete $args{roles}};
  return $self->viewfield_class->new_with_traits({
    traits => [@traits],
    field => $field,
    view => $self,
    %args,
  });
}

############
#
# ViewField
#
############

1;