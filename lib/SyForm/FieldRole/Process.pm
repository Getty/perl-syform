package SyForm::FieldRole::Process;
# ABSTRACT: Role for processed fields

use Moo::Role;
use Module::Runtime qw( use_module );

sub has_value_by_args {
  my ( $self, %args ) = @_;
  return exists($args{$self->name}) ? 1 : 0;
}

sub values_args_by_process_args {
  my ( $self, %args ) = @_;
  my @roles = $self->values_roles_by_process_args(%args);
  return (
    $self->has_value_by_args(%args)
      ? ( $self->name, $self->get_value_by_process_args(%args) ) : (),
    scalar @roles
      ? ( roles => [ @roles ] ) : (),
  );
}

sub values_roles_by_process_args { 
  my ( $self, %args ) = @_;
  return;
}

sub get_value_by_process_args {
  my ( $self, %args ) = @_;
  return $self->get_value_by_process_arg($args{$self->name});
}

sub get_value_by_process_arg {
  my ( $self, $arg ) = @_;
  return $arg;
}

has viewfield_roles => (
  is => 'lazy',
);

sub _build_viewfield_roles {
  my ( $self ) = @_;
  return [];
}

has viewfield_class => (
  is => 'lazy',
);

sub _build_viewfield_class {
  my ( $self ) = @_;
  return use_module('SyForm::ViewField');
}

sub viewfields_for_view {
  my ( $self, $view ) = @_;
  my @viewfield_roles = @{$self->viewfield_roles};
  my %viewfield_args = $self->viewfield_args_by_view($view);
  if (defined $viewfield_args{roles}) {
    push @viewfield_roles, @{delete $viewfield_args{roles}};
  }
  return $self->create_viewfield_for_view($view,%viewfield_args);
}

sub create_viewfield_for_view {
  my ( $self, $view, %args ) = @_;
  my @traits = defined $args{roles} ? @{delete $args{roles}} : ();
  my $viewfield_class = $self->viewfield_class;
  for my $trait (@traits) {
    $viewfield_class = $viewfield_class->with_traits($trait)
      unless $viewfield_class->does($trait);
  }
  return $viewfield_class->new({
    syform => $self->syform,
    field => $self,
    %args,
  });
}

sub viewfield_fields_list_by_view {
  my ( $self, $view ) = @_;
  return $self->name, { $self->viewfield_args_by_view($view) };
}

sub viewfield_args_by_view {
  my ( $self, $view ) = @_;
  return 
    label => $self->label,
    name => $self->name,
    $view->has_results && $view->results->values->has_value($self->name)
      ? ( value => $view->results->values->get_value($self->name) ) : (),
    $view->has_results && $view->results->has_result($self->name)
      ? ( result => $view->results->get_result($self->name) ) : ();
}

sub has_result_by_values {
  my ( $self, $values ) = @_;
  return $values->has_value($self->name) ? 1 : 0;
}

sub results_args_by_values {
  my ( $self, $values ) = @_;
  my @roles = $self->results_roles_by_values($values);
  return (
    $self->has_result_by_values($values)
      ? ( $self->name, $self->get_result_by_values($values) ) : (),
    scalar @roles
      ? ( roles => [ @roles ] ) : (),
  );
}

sub results_roles_by_values {
  my ( $self, $values ) = @_;
  return;
}

sub get_result_by_values {
  my ( $self, $values ) = @_;
  return $self->get_result_by_value($values->get_value($self->name));
}

sub get_result_by_value {
  my ( $self, $value ) = @_;
  return $value;
}

sub view_args_by_results {
  my ( $self, $results ) = @_;
  my @roles = $self->view_roles_by_results($results);
  return (
    scalar @roles
      ? ( roles => [ @roles ] ) : (),
    $self->custom_view_args_by_results,
  );
}

sub custom_view_args_by_results {
  my ( $self, $results ) = @_;
  return;
}

sub view_roles_by_results {
  my ( $self, $results ) = @_;
  return;
}

1;
