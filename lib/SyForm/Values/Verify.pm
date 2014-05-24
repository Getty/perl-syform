package SyForm::Values::Verify;
# ABSTRACT: Verification of values for the SyForm::Results

use Moose::Role;
use Syccess;
use namespace::clean -except => 'meta';

around create_results => sub {
  my ( $orig, $self, %args ) = @_;
  my $no_success = (exists $args{success} && !$args{success}) ? 1 : 0;
  my $syccess_result = $self->verify_values($self);
  for my $field (@{$self->syform->verify_process_fields}) {
    my $field_name = $field->name;
    my @field_errors = @{$syccess_result->errors($field_name)};
    if (scalar @field_errors > 0) {
      unless ($self->syform->field($field_name)->no_delete_on_invalid_result) {
        delete $args{$field_name} if exists $args{$field_name};
      }
    }
  }
  my $validation_success = $syccess_result->success;
  $args{success} = $no_success ? 0 : $validation_success ? 1 : 0; 
  $args{syccess_result} = $syccess_result;
  return $self->$orig(%args);
};

# extra function to make it overrideable for other roles to limit
# functionality of this module
sub syccess_directives {
  @SyForm::Field::Verify::syccess_directives
}

sub verify_values {
  my ( $self, $values ) = @_;
  my @fields;
  my %params;
  for my $field (@{$self->syform->verify_process_fields}) {
    my $name = $field->name;
    my %args;
    for ($self->syccess_directives) {
      my $has = 'has_'.$_;
      $args{$_} = $field->$_ if $field->$has;
    }
    if (%args) {
      push @fields, $name, { %args };
      $params{$name} = $values->get_value($name) if $values->has_value($name);
    }
  }
  return Syccess->new(
    fields => [ @fields ],
  )->validate( %params );
};

1;
