package SyForm::Values;
# ABSTRACT: Values given of the fields through the process args

use Moose::Role;
use List::MoreUtils qw( uniq );
use namespace::clean -except => 'meta';

with qw(
  MooseX::Traits
  SyForm::Fields
);

has syform => (
  is => 'ro',
  isa => 'SyForm',
  required => 1,
  handles => [qw(
    field
  )],
);

has values => (
  is => 'ro',
  isa => 'HashRef',
  required => 1,
);
sub as_hashref { $_[0]->values }

has results => (
  is => 'ro',
  does => 'SyForm::Results',
  lazy_build => 1,
);

sub _build_results {
  my ( $self ) = @_;
  my $results;
  eval {
    my %results_args;
    my @results_traits = @{$self->results_roles};
    for my $field (@{$self->syform->process_fields}) {
      my %field_results_args = $field->results_args_by_values($self);
      push @results_traits, @{delete $field_results_args{roles}}
        if defined $field_results_args{roles};
      $results_args{$_} = $field_results_args{$_} for keys %field_results_args;
    }
    $results = $self->create_results(
      roles => [uniq @results_traits],
      %results_args,
    );
  };
  SyForm->throw( UnknownErrorOnValuesBuildResults => $self, $@ ) if $@;
  return $results;
}

sub create_results {
  my ( $self, %args ) = @_;
  my @traits = @{delete $args{roles}};
  $args{field_names} = [map { $_->name } @{$self->syform->process_fields}]
    unless defined $args{field_names};
  my %results;
  for (@{$args{field_names}}) {
    $results{$_} = delete $args{$_} if defined $args{$_};
  }
  return $self->results_class->new_with_traits({
    scalar @traits ? ( traits => [@traits] ) : (),
    values => $self,
    results => { %results },
    %args
  });
}

has results_object_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);
sub _build_results_object_class { $_[0]->syform->object_class }

has results_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy => 1,
  default => sub {[]},
);

sub _get_results_meta_attribute {
  my ( $self, $field, %args ) = @_; 
  return $self->syform->meta_attributes_class->new($field->name,
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
  );
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

sub get_value {
  my ( $self, $name ) = @_;
  return $self->values->{$name};
}

sub has_value {
  my ( $self, $name ) = @_;
  return exists($self->values->{$name}) ? 1 : 0;
}

1;