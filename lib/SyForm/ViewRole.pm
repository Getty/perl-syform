package SyForm::ViewRole;
# ABSTRACT: View role for SyForm::Results and SyForm::ViewField

use Moo::Role;
use Tie::IxHash;
use Module::Runtime qw( use_module );

has results => (
  is => 'ro',
  required => 1,
  handles => [qw(
    syform
    values
    has_name name
  )],
);
sub has_results { 1 } # results should be optional

has field_names => (
  is => 'lazy',
);

sub _build_field_names {
  my ( $self ) = @_;
  return [ map { $_->name } $self->fields->Values ];
}

has fields => (
  is => 'lazy',
  init_arg => undef,
);
sub viewfields { shift->fields }
sub field { shift->fields->FETCH(@_) }
sub viewfield { shift->fields->FETCH(@_) }

sub _build_fields {
  my ( $self ) = @_;
  my $fields = Tie::IxHash->new;
  for my $field ($self->syform->fields->Values) {
    $fields->Push(map { $_->name, $_ } $field->viewfields_for_view($self))
      if $field->can('viewfields_for_view');
  }
  return $fields;
}

1;