package SyForm::Verify;
# ABSTRACT: Main verification logic

use Moose::Role;
use Data::Verifier;
use namespace::autoclean;

has verify_filters => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  predicate => 'has_verify_filters',
);

around create_results => sub {
  my ( $orig, $self, $values, %args ) = @_;
  my $no_success = exists $args{success} && !$args{success} ? 1 : 0;
  my $verify_results = $self->verify_values($values);
  unless ($verify_results->success) {
    for my $field (@{$self->process_fields}) {
      if ($verify_results->is_invalid($field->name)) {
        unless ($field->no_delete_on_invalid_result) {
          delete $args{$field->name} if exists $args{$field->name};
        }
      }
    }
  }
  $args{success} = $no_success ? 0 : $verify_results->success ? 1 : 0; 
  $args{verify_results} = $verify_results;
  return $self->$orig($values,%args);
};

sub verify_values {
  my ( $self, $values ) = @_;
  my %profile;
  for my $field (@{$self->process_fields}) {
    next unless $field->does('SyForm::Field::Verify');
    my $name = $field->name;
    my %args;
    $args{required} = $field->required if $field->has_required;
    $args{type} = $field->type if $field->type;
    $args{filters} = $field->verify_filters if $field->has_verify_filters;
    if (%args) {
      $profile{$name} = { %args };
    }
  }
  my $dv = Data::Verifier->new(
    $self->has_verify_filters ? ( filters => $self->verify_filters ) : (),
    profile => { %profile }
  );
  return $dv->verify($values->as_hashref);
};

1;
