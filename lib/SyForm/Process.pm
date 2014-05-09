package SyForm::Process;
# ABSTRACT: Role for processed fields

use Moose::Role;
use Moose::Meta::Class;
use Moose::Meta::Attribute;
use List::MoreUtils qw( uniq );
use namespace::clean;

#########
#
# Values
#
#########

has values_object_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);
sub _build_values_object_class { $_[0]->object_class }

has values_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy_build => 1,
);

sub _build_values_roles {[]}

has values_metaclass => (
  isa => 'Moose::Meta::Class',
  is => 'ro',
  lazy_build => 1,
);

sub _build_values_metaclass {
  my ( $self ) = @_;
  return Moose::Meta::Class->create(
    (ref $self).'::Values',
    superclasses => [$self->values_object_class],
    roles => [ 'SyForm::Values' ],
  );
}

has values_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_values_class {
  my ( $self ) = @_;
  return $self->values_metaclass->name;
}

##########
#
# Process
#
##########

has process_fields => (
  is => 'ro',
  isa => 'ArrayRef[SyForm::Field]',
  lazy_build => 1,
);

sub _build_process_fields {
  my ( $self ) = @_;
  return [grep { $_->does($self->field_process_role) } $self->fields->Values];
}

sub process {
  my @process_args = @_;
  my ( $self, %args ) = @_;
  my $view;
  eval { $view = $self->process_view(%args) };
  SyForm->throw( UnknownErrorOnProcess => $self,[@process_args], $@ ) if $@;
  return $view;
}

#################
#
# Process Values
#
#################

sub process_values {
  my @process_values_args = @_;
  my ( $self, %args ) = @_;
  my $values;
  eval {
    my %values_args;
    my @values_traits = @{$self->values_roles};
    for my $field (@{$self->process_fields}) {
      my %field_values_args = $field->values_args_by_process_args(%args);
      push @values_traits, @{delete $field_values_args{roles}}
        if defined $field_values_args{roles};
      $values_args{$_} = $field_values_args{$_} for keys %field_values_args;
    }
    $values = $self->create_values(
      roles => [uniq @values_traits],
      %values_args,
    );
  };
  SyForm->throw( UnknownErrorOnProcessValues => $self,[@process_values_args], $@ ) if $@;
  return $values;
}

sub create_values {
  my ( $self, %args ) = @_;
  my @traits = @{delete $args{roles}};
  my $values_as_hashref = delete $args{values_as_hashref};
  $args{field_names} = [map { $_->name } @{$self->process_fields}]
    unless defined $args{field_names};
  my %values;
  for (@{$args{field_names}}) {
    $values{$_} = delete $args{$_} if defined $args{$_};
  }
  return $self->values_class->new_with_traits({
    syform => $self,
    scalar @traits ? ( traits => [@traits] ) : (),
    values => { %values },
    %args,
  });
}

##################
#
# Process Results
#
##################

has results_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy_build => 1,
);

sub _build_results_roles {[]}

sub process_results {
  my ( $self, %args ) = @_;
  my $values = $self->process_values(%args);
  return $values->results;
}

###############
#
# Process View
#
###############

has view_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy_build => 1,
);

sub _build_view_roles {[]}

sub process_view {
  my ( $self, %args ) = @_;
  my $results = $self->process_results(%args);
  return $results->view;
}

1;
