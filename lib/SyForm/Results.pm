package SyForm::Results;
# ABSTRACT: Results of the processing of SyForm::Values

use Moo;

with qw(
  MooX::Traits
  SyForm::ResultsRole::Success
  SyForm::ResultsRole::Verify
);

has values => (
  is => 'ro',
  required => 1,
  handles => [qw(
    syform
    field
    field_names
  )],
);

has results => (
  is => 'ro',
  required => 1,
);
sub as_hashref { $_[0]->results }

has view => (
  is => 'lazy',
);

sub _build_view {
  my ( $self, %args ) = @_;
  my $view;
  eval {
    my %view_args;
    for my $field ($self->syform->fields->Values) {
      my %field_view_args = $field->view_args_by_results($self);
      $view_args{$_} = $field_view_args{$_} for keys %field_view_args;
    }
    $view = $self->create_view( %view_args );
  };
  SyForm->throw( UnknownErrorOnResultsBuildView => $self, $@ ) if $@;
  return $view;
}

sub create_view {
  my ( $self, %args ) = @_;
  return $self->syform->loaded_view_class->new({
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