package SyForm;
# ABSTRACT: SyForm - a role driven form management

use Moose::Role;
use Tie::IxHash;
use Carp qw( croak );

has fields => (
  isa => 'Tie::IxHash',
  is => 'ro',
  init_arg => undef,
  lazy_build => 1,
);
sub field { shift->fields->FETCH(@_) }

has fields_list => (
  isa => 'ArrayRef[Str|HashRef]',
  is => 'ro',
  init_arg => 'fields',
  required => 1,
);

has field_roles_by_arg => (
  isa => 'Tie::IxHash',
  is => 'ro',
  lazy_build => 1,
);

# order is relevant
sub _build_field_roles_by_arg {Tie::IxHash->new(

  # first fill up missing args with defaults
  default => 'SyForm::Field::Default',

  # visuals can be placed everywhere
  label => 'SyForm::Field::Label',
  html => 'SyForm::Field::HTML',
  ###

  # Block readonly before verification
  readonly => 'SyForm::Field::Readonly',

  # Verify last
  (map { $_ => 'SyForm::Field::Verify' } qw(
    required type filters
  )),

)}

has default_field_args => (
  isa => 'HashRef',
  is => 'ro',
  predicate => 'has_default_field_args',
);

sub _build_fields {
  my ( $self ) = @_;
  my $fields = Tie::IxHash->new;
  my $fields_list = Tie::IxHash->new(@{$self->fields_list});
  for my $name ($fields_list->Keys) {
    my %field_args = %{$fields_list->FETCH($name)};
    $fields->Push($name, $self->_create_field($name,
      %field_args, $self->has_default_field_args
        ? (%{$self->default_field_args}) : (),
    ));
  }
  return $fields;
}

sub _create_field {
  my ( $self, $name, %field_args ) = @_;
  my $class = delete $field_args{class} || $self->default_field_class;
  my $traits = delete $field_args{traits} || [];
  unshift @{$traits}, $self->field_process_role
    unless delete $field_args{no_process};
  for my $arg ($self->field_roles_by_arg->Keys) {
    if (exists $field_args{$arg}) {
      push @{$traits}, $self->field_roles_by_arg->FETCH($arg);
    }
  }
  $class->new_with_traits(
    syform => $self,
    traits => $traits,
    name => $name,
    %field_args,
  );
}

has field_process_role => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_field_process_role { 'SyForm::Field::Process' }

has default_field_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  predicate => 'has_default_field_roles',
);

has default_field_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_default_field_class {
  my ( $self ) = @_;
  return $self->_default_field_metaclass->name;
}

has default_field_base_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_default_field_base_class { 'Moose::Object' }

has _default_field_metaclass => (
  isa => 'Moose::Meta::Class',
  is => 'ro',
  lazy_build => 1,
);

sub _build__default_field_metaclass {
  my ( $self ) = @_;
  return Moose::Meta::Class->create_anon_class(
    superclasses => [$self->default_field_base_class],
    roles => [ 'SyForm::Field', 'MooseX::Traits',
      $self->has_default_field_roles ? (@{$self->default_field_roles}) : (),
    ],
    cache => 1,
  )
}

sub create {
  my ( $class, $field_list_arg, %args ) = @_;
  my $ref = ref $class;
  $class = $ref if $ref;

  my $form_roles = delete $args{roles} || [];
  unshift @{$form_roles}, 'SyForm', 'MooseX::Traits';
  my $form_class = delete $args{class};

  unless ($form_class) {
    my $form_base_class = delete $args{form_base_class} || 'Moose::Object';
    my $form_metaclass = Moose::Meta::Class->create_anon_class(
      superclasses => [$form_base_class],
      roles => $form_roles,
      cache => 1,
    );
    $form_class = $form_metaclass->name;
  }

  my $traits = [];

  return $form_class->new_with_traits(
    traits => $traits,
    fields => $field_list_arg,
  );
}

has processed => (
  is => 'rw',
  isa => 'HashRef',
  predicate => 'is_processed',
);

sub process {
  my ( $self, %args ) = @_;
  $self->processed({ %args });
  $self->reset_result;
  my $ok = 1;
  for my $field ($self->process_fields) {
    $ok = 0 unless $field->process(%args);
  }
  return $ok;
}

sub results {
  my ( $self ) = @_;
  return unless $self->is_processed;
  my %results;
  for my $field ($self->process_fields) {
    $results{$field->name} = $field->result
      if $field->has_result;
  }
  return { %results };  
}

sub reset_result {
  my ( $self ) = @_;
  $_->reset_result for ($self->process_fields);
}

sub process_fields {
  my ( $self ) = @_;
  return grep {
    $_->does($self->field_process_role)
  } $self->fields->Values;
}

1;

=encoding utf8

=head1 SYNOPSIS

  use SyForm;

  my $form = SyForm->create([
    'name' => {
      type => 'Str',
      required => 1,
      label => 'Your name',
    },
    'age' => {
      type => 'Int',
      label => 'Your age',
    },
  ]);

  $form->does('SyForm'); # its all roles
  $form->field('name')->does('SyForm::Field');
  $form->field('name')->does('SyForm::Field::Label');
  $form->field('name')->does('SyForm::Field::Verify');

  if ($form->process( name => 'YoCoolCopKiller', age => 'eight' )) {
    my $hash_of_results = $form->results;
  }

=head1 DESCRIPTION

SyForm is developed for L<SyContent|https://sycontent.de/>.

=head1 SUPPORT

IRC

  Join #sycontent on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/SyContent/SyForm
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/SyContent/SyForm/issues


