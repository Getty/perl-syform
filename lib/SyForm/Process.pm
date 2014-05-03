package SyForm::Process;
# ABSTRACT: Role for processed fields

use Moose::Role;
use Moose::Meta::Class;
use Moose::Meta::Attribute;
use List::MoreUtils qw( uniq );
use namespace::autoclean;

#################
#
# Meta Attribute
#
#################

has meta_attributes_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_meta_attributes_class {
  my ( $self ) = @_;
  return $self->_meta_attributes_metaclass->name;
}

has _meta_attributes_metaclass => (
  isa => 'Moose::Meta::Class',
  is => 'ro',
  lazy_build => 1,
);

sub _build__meta_attributes_metaclass {
  my ( $self ) = @_;
  return Moose::Meta::Class->create_anon_class(
    superclasses => ['Moose::Meta::Attribute'],
    roles => [
      'SyForm::Meta::Attribute::Field', 'MooseX::Traits',
      @{$self->_meta_attributes_metaclass_roles},
    ],
  )
}

has _meta_attributes_metaclass_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy => 1,
  default => sub {[]},
);

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
  lazy => 1,
  default => sub {[]},
);

sub _get_values_meta_attribute {
  my ( $self, $field, %args ) = @_;
  return $self->meta_attributes_class->new($field->name,
    is => 'ro',
    predicate => $field->has_name,
    field => $field,
    %args,
  );
}

has _values_metaclass => (
  isa => 'Moose::Meta::Class',
  is => 'ro',
  lazy_build => 1,
);

sub _build__values_metaclass {
  my ( $self ) = @_;
  return Moose::Meta::Class->create(
    (ref $self).'::Values',
    superclasses => [$self->values_object_class],
    roles => [ 'SyForm::Values' ],
    attributes => [map {
      $self->_get_values_meta_attribute($_);
    } @{$self->process_fields}],
  );
}

has values_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_values_class {
  my ( $self ) = @_;
  return $self->_values_metaclass->name;
}

##########
#
# Results
#
##########

has results_object_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);
sub _build_results_object_class { $_[0]->object_class }

has results_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy => 1,
  default => sub {[]},
);

sub _get_results_meta_attribute {
  my ( $self, $field, %args ) = @_; 
  return $self->meta_attributes_class->new($field->name,
    is => 'ro',
    predicate => $field->has_name,
    field => $field,
    %args,
  );
}

has _results_metaclass => (
  isa => 'Moose::Meta::Class',
  is => 'ro',
  lazy_build => 1,
);

sub _build__results_metaclass {
  my ( $self ) = @_;
  return Moose::Meta::Class->create(
    (ref $self).'::Results',
    superclasses => [$self->results_object_class],
    roles => [ 'SyForm::Results' ],
    attributes => [map {
      $self->_get_results_meta_attribute($_);
    } @{$self->process_fields}],
  )
}

has results_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_results_class {
  my ( $self ) = @_;
  return $self->_results_metaclass->name;
}

#######
#
# View
#
#######

has view_object_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);
sub _build_view_object_class { $_[0]->object_class }

has view_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy => 1,
  default => sub {[]},
);

has _view_metaclass => (
  isa => 'Moose::Meta::Class',
  is => 'ro',
  lazy_build => 1,
);

sub _build__view_metaclass {
  my ( $self ) = @_;
  return Moose::Meta::Class->create(
    (ref $self).'::View',
    superclasses => [$self->view_object_class],
    roles => [ 'SyForm::View' ],
  )
}

has view_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_view_class {
  my ( $self ) = @_;
  return $self->_view_metaclass->name;
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
  my $values_as_hashref = delete $args{values_as_hashref};
  eval {
    my %values_args;
    my @values_traits;
    for my $field (@{$self->process_fields}) {
      if ($field->has_value_by_args(%args)) {
        my ( $value, @traits ) = $field->value_values_roles_by_args(%args);
        $values_args{$field->name} = $value;
        push @values_traits, @traits;
      } else {
        push @values_traits, $field->values_roles_by_args(%args);
      }
    }
    $values = $self->create_values(
      roles => [uniq @values_traits],
      values_as_hashref => $values_as_hashref,
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
  return { %args } if $values_as_hashref;
  return $self->values_class->new_with_traits({
    traits => [@traits],
    syform => $self,
    %args,
  });
}

##################
#
# Process Results
#
##################

sub process_results {
  my @process_results_args = @_;
  my ( $self, %args ) = @_;
  my $results;
  my $results_as_hashref = delete $args{results_as_hashref};
  my $values = $self->process_values(%args);
  eval {
    my %results_args;
    my @results_traits;
    for my $field (@{$self->process_fields}) {
      if ($field->has_result_by_values($values)) {
        my ( $value, @traits ) = $field->result_results_roles_by_values($values);
        $results_args{$field->name} = $value;
        push @results_traits, @traits;
      } else {
        push @results_traits, $field->results_roles_by_values($values);
      }
    }
    $results = $self->create_results($values, 
      roles => [uniq @results_traits],
      results_as_hashref => $results_as_hashref,
      %results_args,
    );
  };
  SyForm->throw( UnknownErrorOnProcessResults => $self,[@process_results_args], $@ ) if $@;
  return $results;
}

sub create_results {
  my ( $self, $values, %args ) = @_;
  my @traits = @{delete $args{roles}};
  my $results_as_hashref = delete $args{results_as_hashref};
  $args{field_names} = [map { $_->name } @{$self->process_fields}]
    unless defined $args{field_names};
  return { %args } if $results_as_hashref;
  return $self->results_class->new_with_traits({
    traits => [@traits],
    values => $values,
    %args
  });
}

###############
#
# Process View
#
###############

sub process_view {
  my @process_view_args = @_;
  my ( $self, %args ) = @_;
  my $view;
  my $results = $self->process_results(%args);
  eval {
    my %viewfield_traits;
    my @view_traits;
    for my $field (@{$self->process_fields}) {
      my @vfrvr = $field->viewfield_roles_view_roles_by_results($results);
      my $count = scalar @vfrvr;
      if ($count == 0) {
        # explicit does nothing
      } elsif ($count == 1) {
        my @vfr = ref $vfrvr[0] eq 'ARRAY' ? (@{$vfrvr[0]}) : @vfrvr;
        $viewfield_traits{$field->name} = [ @vfr ];
      } else {
        my @vfr = @{shift @vfrvr};
        my @vr = ref $vfrvr[0] eq 'ARRAY' ? (@{$vfrvr[0]}) : @vfrvr;
        $viewfield_traits{$field->name} = [ @vfr ];
        push @view_traits, @vr;
      }
    }
    $view = $self->create_view($results,
      roles => [uniq @view_traits],
      viewfield_roles => { %viewfield_traits },
    );
  };
  SyForm->throw( UnknownErrorOnProcessView => $self,[@process_view_args], $@ ) if $@;
  return $view;
}

sub create_view {
  my ( $self, $results, %args ) = @_;
  my @traits = @{delete $args{roles}};
  my %viewfield_traits = %{delete $args{viewfield_roles}};
  return $self->view_class->new_with_traits({
    traits => [ @traits ],
    results => $results,
    viewfield_roles => { %viewfield_traits },
    %args,
  });
}

1;
