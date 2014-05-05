package SyForm::Values::Verify;
# ABSTRACT: Verification of values for the SyForm::Results

use Moose::Role;
use Validation::Class::Simple;
use namespace::clean -except => 'meta';

around create_results => sub {
  my ( $orig, $self, %args ) = @_;
  my $no_success = (exists $args{success} && !$args{success}) ? 1 : 0;
  my $validation_class = $self->verify_values($self);
  my @vals = $validation_class->fields->values;
  for my $validation_field ($validation_class->fields->values) {
    my $field_name = $validation_field->name;
    if (!$validation_class->validate($field_name)) {
      unless ($self->syform->field($field_name)->no_delete_on_invalid_result) {
        delete $args{$field_name} if exists $args{$field_name};
      }
    } elsif (exists $args{$field_name}) {
      my ( $verified_value ) = $validation_class->get_values($field_name);
      $args{$field_name} = $verified_value;
    }
  }
  my $validation_success = $validation_class->validate;
  $args{success} = $no_success ? 0 : $validation_success ? 1 : 0; 
  $args{validation_class} = $validation_class;
  return $self->$orig(%args);
};

# extra function to make it overrideable for other roles to limit
# functionality of this module
sub validation_class_directives {
  @SyForm::Field::Verify::validation_class_directives
}

sub verify_values {
  my ( $self, $values ) = @_;
  my %validation_fields;
  my %params;
  for my $field (@{$self->syform->verify_process_fields}) {
    my $name = $field->name;
    my %args;
    for ($self->validation_class_directives) {
      my $has = 'has_'.$_;
      $args{$_} = $field->$_ if $field->$has;
    }
    if (%args) {
      $validation_fields{$name} = { %args };
      $params{$name} = $values->get_value($name)
        if $values->has_value($name) || $field->required;
      # required case, cause Validate::Class doesnt really
      # check for required if the param doesnt exist. 
    }
  }
  return Validation::Class::Simple->new(
    fields => { %validation_fields },
    params => { %params },
  );
};

1;
