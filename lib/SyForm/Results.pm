package SyForm::Results;
# ABSTRACT: Results of the processing of SyForm::Values

use Moose::Role;
use List::MoreUtils qw( uniq );
use namespace::clean -except => 'meta';

with qw(
  MooseX::Traits
  SyForm::Fields
);

has values => (
  is => 'ro',
  does => 'SyForm::Values',
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
  does => 'SyForm::View',
  lazy_build => 1,
);

sub _build_view {
  my ( $self, %args ) = @_;
  my $view;
  eval {
    my %view_args;
    my %viewfield_traits;
    my @view_traits = @{$self->view_roles};
    for my $field (@{$self->syform->process_fields}) {
      my %field_view_args = $field->view_args_by_results($self);
      push @view_traits, @{delete $field_view_args{roles}}
        if defined $field_view_args{roles};
      if (defined $field_view_args{viewfield_roles}) {
        my $field_viewfield_roles = delete $field_view_args{viewfield_roles};
        my $ref = ref $field_viewfield_roles;
        $viewfield_traits{$field->name} = []
          unless defined $viewfield_traits{$field->name};
        if (!$ref) {
          push @{$viewfield_traits{$field->name}}, $field_viewfield_roles;
        } elsif ($ref eq 'ARRAY') {
          push @{$viewfield_traits{$field->name}}, @{$field_viewfield_roles};
        } elsif ($ref eq 'HASH') {
          for my $key (%{$field_viewfield_roles}) {
            push @{$viewfield_traits{$key}}, @{$field_viewfield_roles->{$key}};
          }
        } else {
          SyForm->throw( UnexpectedValueOnViewFieldRoles => $field, $ref );
        }
      }
      $view_args{$_} = $field_view_args{$_} for keys %field_view_args;
    }
    $view = $self->create_view(
      roles => [uniq @view_traits],
      viewfield_roles => { %viewfield_traits },
      %view_args,
    );
  };
  SyForm->throw( UnknownErrorOnResultsBuildView => $self, $@ ) if $@;
  return $view;
}

sub create_view {
  my ( $self, %args ) = @_;
  my @traits = @{delete $args{roles}};
  my %viewfield_traits = %{delete $args{viewfield_roles}};
  return $self->view_class->new_with_traits({
    scalar @traits ? ( traits => [@traits] ) : (),
    results => $self,
    viewfield_roles => { %viewfield_traits },
    %args,
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

has view_object_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);
sub _build_view_object_class { $_[0]->syform->object_class }

has view_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy_build => 1,
);

sub _build_view_roles {
  my ( $self ) = @_;
  return $self->values->view_roles;
}

has view_metaclass => (
  isa => 'Moose::Meta::Class',
  is => 'ro',
  lazy_build => 1,
);

sub _build_view_metaclass {
  my ( $self ) = @_;
  return Moose::Meta::Class->create(
    (ref $self->syform).'::View',
    superclasses => [$self->view_object_class],
    roles => [ 'SyForm::View' ],
  );
}

has view_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_view_class {
  my ( $self ) = @_;
  return $self->view_metaclass->name;
}

1;