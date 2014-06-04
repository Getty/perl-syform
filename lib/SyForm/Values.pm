package SyForm::Values;
# ABSTRACT: Values given of the fields through the process args

use Moose;
use namespace::clean -except => 'meta';

with qw(
  MooseX::Traits
);

has syform => (
  is => 'ro',
  isa => 'SyForm',
  required => 1,
  handles => [qw(
    field
    field_names
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
  lazy_build => 1,
);

sub _build_results {
  my ( $self ) = @_;
  my $results;
  eval {
    my %results_args;
    my @results_traits = @{$self->syform->results_roles};
    for my $field ($self->syform->fields->Values) {
      my %field_results_args = $field->results_args_by_values($self);
      push @results_traits, @{delete $field_results_args{roles}}
        if defined $field_results_args{roles};
      $results_args{$_} = $field_results_args{$_} for keys %field_results_args;
    }
    $results = $self->create_results(
      roles => [ @results_traits ],
      %results_args,
    );
  };
  SyForm->throw( UnknownErrorOnValuesBuildResults => $self, $@ ) if $@;
  return $results;
}

sub create_results {
  my ( $self, %args ) = @_;
  my @traits = defined $args{roles} ? @{delete $args{roles}} : ();
  my %results;
  for my $field ($self->syform->fields->Values) {
    my $name = $field->name;
    $results{$name} = delete $args{$name} if exists $args{$name};
  }
  my $results_class = $self->syform->results_class;
  for my $trait (@traits) {
    $results_class = $results_class->with_traits($trait)
      unless $results_class->does($trait);
  }
  return $results_class->new({
    values => $self,
    results => { %results },
    %args
  });
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