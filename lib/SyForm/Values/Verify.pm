package SyForm::Values::Verify;
# ABSTRACT:

use Moose::Role;
use Data::Verifier;
use namespace::autoclean;

around create_results => sub {
  my ( $orig, $self, %args ) = @_;
  my $no_success = exists $args{success} && !$args{success} ? 1 : 0;
  my $verify_results = $self->verify_values($self);
  for my $field (@{$self->syform->verify_process_fields}) {
    if ($verify_results->is_invalid($field->name)) {
      unless ($field->no_delete_on_invalid_result) {
        delete $args{$field->name} if exists $args{$field->name};
      }
    } elsif (exists $args{$field->name}) {
      my $verified_value = $verify_results->get_value($field->name);
      $args{$field->name} = $verified_value;
    }
  }
  $args{success} = $no_success ? 0 : $verify_results->success ? 1 : 0; 
  $args{verify_results} = $verify_results;
  return $self->$orig(%args);
};

sub verify_values {
  my ( $self, $values ) = @_;
  my %profile;
  for my $field (@{$self->syform->verify_process_fields}) {
    my $name = $field->name;
    my %args;
    if ($field->does('SyForm::Field::Verify')) {
      $args{required} = $field->required if $field->has_required;
      $args{type} = $field->type if $field->type;
      $args{filters} = $field->verify_filters if $field->has_verify_filters;
    }
    if (%args) {
      $profile{$name} = { %args };
    }
  }
  my $dv = Data::Verifier->new(
    $self->syform->has_verify_filters ? ( filters => $self->syform->verify_filters ) : (),
    profile => { %profile }
  );
  return $dv->verify($values->as_hashref);
};

1;
