package SyForm::View;
# ABSTRACT: Container for SyForm::Results and SyForm::ViewField

use Moose;
use Tie::IxHash;
use Module::Runtime qw( use_module );
use namespace::clean -except => 'meta';

with qw(
  MooseX::Traits
);

has results => (
  is => 'ro',
  isa => 'SyForm::Results',
  predicate => 'has_results',
  handles => [qw(
    syform
    values
  )],
);

has field_names => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  lazy_build => 1,
);

sub _build_field_names {
  my ( $self ) = @_;
  return [ map { $_->name } $self->fields->Values ];
}

has fields => (
  is => 'ro',
  isa => 'Tie::IxHash',
  lazy_build => 1,
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