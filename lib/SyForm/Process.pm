package SyForm::Process;
# ABSTRACT: Role for processed fields

use Moose::Role;
use List::MoreUtils qw( uniq );
use Module::Runtime qw( use_module );
use namespace::clean;

has field_process_role => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_field_process_role { 'SyForm::Field::Process' }

around _build_field_roles => sub {
  my ( $orig, $self ) = @_;
  my @roles = @{$self->$orig};
  return [ $self->field_process_role, @roles ];
};

#########
#
# Values
#
#########

has values_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy_build => 1,
);

sub _build_values_roles {
  my ( $self ) = @_;
  return [];
}

has values_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_values_class {
  my ( $self ) = @_;
  return use_module('SyForm::Values');
}

##########
#
# Process
#
##########

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
    for my $field ($self->fields->Values) {
      my %field_values_args = $field->values_args_by_process_args(%args);
      push @values_traits, @{delete $field_values_args{roles}}
        if defined $field_values_args{roles};
      $values_args{$_} = $field_values_args{$_} for keys %field_values_args;
    }
    $values = $self->create_values(
      roles => \@values_traits,
      %values_args,
    );
  };
  SyForm->throw( UnknownErrorOnProcessValues => $self,[@process_values_args], $@ ) if $@;
  return $values;
}

sub create_values {
  my ( $self, %args ) = @_;
  my @traits = defined $args{roles} ? @{delete $args{roles}} : ();
  my %values;
  for my $field ($self->fields->Values) {
    my $name = $field->name;
    $values{$name} = delete $args{$name} if exists $args{$name};
  }
  my $values_class = $self->values_class;
  for my $trait (@traits) {
    $values_class = $values_class->with_traits($trait)
      unless $values_class->does($trait);
  }
  return $values_class->new({
    syform => $self,
    values => { %values },
    %args,
  });
}

##########
#
# Results
#
##########

has results_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_results_class {
  my ( $self ) = @_;
  return use_module('SyForm::Results');
}

has results_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy_build => 1,
);

sub _build_results_roles {
  my ( $self ) = @_;
  return [];
}

sub process_results {
  my ( $self, %args ) = @_;
  my $values = $self->process_values(%args);
  return $values->results;
}

#######
#
# View
#
#######

has view_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy_build => 1,
);

sub _build_view_roles {
  my ( $self ) = @_;
  return [];
}

has view_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_view_class {
  my ( $self ) = @_;
  return use_module('SyForm::View');
}

sub process_view {
  my ( $self, %args ) = @_;
  my $results = $self->process_results(%args);
  return $results->view;
}

1;
