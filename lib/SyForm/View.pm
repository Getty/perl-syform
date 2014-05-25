package SyForm::View;
# ABSTRACT: Container for SyForm::Results and SyForm::ViewField

use Moose::Role;
use Tie::IxHash;
use namespace::clean -except => 'meta';

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

has viewfield_roles_for_all => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy_build => 1,
);

sub _build_viewfield_roles_for_all {[]}

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
  [map { $_->name } $self->fields->Values];
}

has fields_list => (
  isa => 'ArrayRef[Str|HashRef]',
  is => 'ro',
  lazy_build => 1,
);

sub _build_fields_list {
  my ( $self ) = @_;
  my @list;
  for my $field ($self->syform->fields->Values) {
    if ($field->can('viewfield_fields_list_by_results')) {
      my $field_list = Tie::IxHash->new($field->viewfield_fields_list_by_results($self->results));
      for my $name ($field_list->Keys) {
        my %args = %{$field_list->FETCH($name)};
        $args{name} = $name;
        push @list, $name, { %args };
      }
    }
  }
  return [ @list ];
}

has fields => (
  is => 'ro',
  isa => 'Tie::IxHash',
  lazy_build => 1,
  init_arg => undef,
);
sub viewfields { shift->fields }
sub field { shift->fields->FETCH(@_) }
sub viewfield { shift->fields->FETCH(@_) }

sub _build_fields {
  my ( $self ) = @_;
  my @viewfield_roles_for_all = @{$self->viewfield_roles_for_all};
  my $fields = Tie::IxHash->new;
  my $fields_list = Tie::IxHash->new(@{$self->fields_list});
  for my $name ($fields_list->Keys) {
    my %viewfield_args = %{$fields_list->FETCH($name)};
    $viewfield_args{roles} = defined $viewfield_args{roles}
      ? [@{$viewfield_args{roles}},@viewfield_roles_for_all]
      : [@viewfield_roles_for_all];
    $fields->Push($name, $self->create_viewfield($self->syform->field($name),
      %viewfield_args,
    ));
  }
  return $fields;
}

sub create_viewfield {
  my ( $self, $field, %args ) = @_;
  my @traits = @{delete $args{roles}};
  return $self->viewfield_class->new_with_traits({
    scalar @traits ? ( traits => [@traits] ) : (),
    field => $field,
    view => $self,
    %args,
  });
}

1;