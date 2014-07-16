package SyForm::ValuesRole::Verify;
# ABSTRACT: Verification of values for the SyForm::Results

use Moo::Role;

around create_results => sub {
  my ( $orig, $self, %args ) = @_;
  my $no_success = (exists $args{success} && !$args{success}) ? 1 : 0;
  my $syccess_result = $self->verify_values($self);
  for my $field ($self->syform->fields->Values) {
    my $field_name = $field->name;
    my @field_errors = @{$syccess_result->errors($field_name)};
    if (scalar @field_errors > 0) {
      if ($self->syform->field($field_name)->delete_on_invalid_result) {
        delete $args{$field_name} if exists $args{$field_name};
      }
    }
  }
  my $validation_success = $syccess_result->success;
  $args{success} = $no_success ? 0 : $validation_success ? 1 : 0; 
  $args{syccess_result} = $syccess_result;
  return $self->$orig(%args);
};

sub verify_values {
  my ( $self, $values ) = @_;
  my @fields;
  my %params;
  for my $field ($self->syform->fields->Values) {
    my $name = $field->name;
    if ($field->has_verify || $field->has_required) {
      my @verify = $field->has_verify ? @{$field->verify} : ();
      unshift @verify, required => 1 if $field->required;
      unshift @verify, label => $field->label;
      push @fields, $name, \@verify;
      $params{$name} = $values->get_value($name) if $values->has_value($name);
    }
  }
  return $self->syform->loaded_syccess_class->new(
    %{$self->syform->syccess},
    fields => [ @fields ],
  )->validate( %params );
};

1;
