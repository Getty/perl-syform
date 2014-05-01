package SyForm::Verify;
# ABSTRACT: Main verification logic

use Moose::Role;
use Data::Verifier;

has verify_filters => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  predicate => 'has_verify_filters',
);

has verify_result => (
  is => 'rw',
  predicate => 'has_verify_result',
  clearer => 'reset_verify_result',
);

after reset_result => sub {
  my ( $self ) = @_;
  $self->reset_verify_result;
};

around process => sub {
  my ( $orig, $self, %args ) = @_;
  my $no_verify = delete $args{no_verify};
  my $ok = $self->$orig(%args);
  unless ($no_verify) {
    my %profile;
    for my $field ($self->process_fields) {
      my $name = $field->name;
      my %args;
      $args{required} = $field->required if $field->has_required;
      $args{type} = $field->type if $field->has_type;
      $args{filters} = $field->verify_filters if $field->has_verify_filters;
      if (%args) {
        $profile{$name} = { %args };
      }
    }
    my $dv = Data::Verifier->new(
      $self->has_verify_filters ? ( filters => $self->verify_filters ) : (),
      profile => { %profile }
    );
    $self->verify_result($dv->verify({ %args }));
    for my $field ($self->process_fields) {
      $field->reset_result if $self->verify_result->is_invalid($field->name);
    }
    return 1 if $self->verify_result->success and $ok;
    return 0 unless $self->verify_result->success;
  }
  return $ok;
};

1;
