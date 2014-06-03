package SyForm::Results;
# ABSTRACT: Results of the processing of SyForm::Values

use Moose;
use namespace::clean -except => 'meta';

with qw(
  MooseX::Traits
);

has values => (
  is => 'ro',
  isa => 'SyForm::Values',
  required => 1,
  handles => [qw(
    syform
    field
  )],
);

has results => (
  is => 'ro',
  isa => 'HashRef',
  required => 1,
);
sub as_hashref { $_[0]->results }

has view => (
  is => 'ro',
  lazy_build => 1,
);

sub _build_view {
  my ( $self, %args ) = @_;
  my $view;
  eval {
    my %view_args;
    my %viewfield_traits;
    my @view_traits = @{$self->syform->view_roles};
    for my $field (@{$self->syform->fields}) {
      my %field_view_args = $field->view_args_by_results($self);
      push @view_traits, @{delete $field_view_args{roles}}
        if defined $field_view_args{roles};
      $view_args{$_} = $field_view_args{$_} for keys %field_view_args;
    }
    $view = $self->create_view(
      roles => [ @view_traits ],
      %view_args,
    );
  };
  SyForm->throw( UnknownErrorOnResultsBuildView => $self, $@ ) if $@;
  return $view;
}

sub create_view {
  my ( $self, %args ) = @_;
  my @traits = defined $args{roles} ? @{delete $args{roles}} : ();
  my $view_class = $self->syform->view_class;
  for my $trait (@traits) {
    $view_class = $view_class->with_traits($trait)
      unless $view_class->does($trait);
  }
  return $view_class->new({
    results => $self,
    %args
  });
}

sub get_result {
  my ( $self, $name ) = @_;
  return $self->results->{$name};
}

sub has_result {
  my ( $self, $name ) = @_;
  return exists($self->results->{$name});
}

1;