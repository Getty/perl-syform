package SyForm;
# ABSTRACT: SyForm - a role driven form management

use Moose::Role;
use Tie::IxHash;
use Carp qw( croak );
use Moose::Util qw( apply_all_roles );
use Moose::Util::TypeConstraints;
use Module::Runtime qw( use_module );

role_type 'SyForm::Field';
role_type 'SyForm::Values';
role_type 'SyForm::Results';

use SyForm::Exception;
use namespace::autoclean;

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
sub _build_field_roles_by_arg {
  my ( $self ) = @_;

  return Tie::IxHash->new(

    default => 'SyForm::Field::Default',

    label => 'SyForm::Field::Label',
    html => 'SyForm::Field::HTML',

    readonly => 'SyForm::Field::Readonly',

    (map { $_ => 'SyForm::Field::Verify' } qw(
      required type filters
    )),

    @{$self->custom_roles_by_arg},

  );

}

has custom_roles_by_arg => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy => 1,
  default => sub {[]},
);

has field_args => (
  isa => 'HashRef',
  is => 'ro',
  predicate => 'has_field_args',
);

sub _build_fields {
  my ( $self ) = @_;
  my $fields = Tie::IxHash->new;
  eval {
    my $fields_list = Tie::IxHash->new(@{$self->fields_list});
    for my $name ($fields_list->Keys) {
      my %field_args = %{$fields_list->FETCH($name)};
      eval {
        $fields->Push($name, $self->_create_field($name,
          %field_args, $self->has_field_args ? (%{$self->field_args}) : (),
        ));
      };
      SyForm->throw( UnknownErrorOnBuildField => $name, { %field_args }, $@ ) if $@;
    }
  };
  SyForm->throw( UnknownErrorOnBuildFields => $self, $@ ) if $@;
  return $fields;
}

sub _create_field {
  my ( $self, $name, %field_args ) = @_;
  my $field;
  my $class = delete $field_args{class} || $self->field_class;
  my $traits = delete $field_args{traits} || [];
  # actually there should be a more decent management of the roles, with
  # a meta layer which supplies function that are used by the plugins
  unshift @{$traits}, $self->field_process_role
    unless delete $field_args{no_process};
  for my $arg ($self->field_roles_by_arg->Keys) {
    if (exists $field_args{$arg}) {
      push @{$traits}, $self->field_roles_by_arg->FETCH($arg);
    }
  }
  return $class->new_with_traits(
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

has field_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy => 1,
  default => sub {[]},
);

has field_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_field_class {
  my ( $self ) = @_;
  return $self->_field_metaclass->name;
}

has field_base_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);
sub _build_field_base_class { 'Moose::Object' }

has _field_metaclass => (
  isa => 'Moose::Meta::Class',
  is => 'ro',
  lazy_build => 1,
);

sub _build__field_metaclass {
  my ( $self ) = @_;
  return Moose::Meta::Class->create(
    (ref $self).'::Field',
    superclasses => [$self->field_base_class],
    roles => [
      'SyForm::Field', 'MooseX::Traits',
      @{$self->field_roles},
    ],
  )
}

sub throw {
  my ( $class, $exception, @args ) = @_;
  if (scalar @args == 0) {
    SyForm::Exception->throw($exception);
  }
  my $exception_class = 'SyForm::Exception::'.$exception;
  use_module($exception_class);
  $exception_class->throw_with_args(@args);
}

sub add_role {
  my ( $self, @roles ) = @_;
  for my $role (@roles) {
    unless ($self->does($role)) {
      apply_all_roles($self, $role);
      $role->can('BUILD')->($self) if $role->can('BUILD');
    }
  }
}

{
  my $CLASS_SERIAL = 0;
  my %default_form_roles_by_arg = (
    label => 'SyForm::Label',
  );
  sub create {
    my @create_args = @_;
    my ( $class, @all_args ) = @_;
    my ( @roles, @field_list_args, %args );
    while (@all_args) {
      my $next_arg = shift @all_args;
      if (ref $next_arg eq 'ARRAY') {
        @field_list_args = @{$next_arg};
        %args = @all_args;
        last;
      } elsif (!ref $next_arg) {
        push @roles, 'SyForm::'.$next_arg;
      } else {
        my $ref = ref $next_arg;
        SyForm->throw( UnexpectedArgToCreate => [@create_args], $ref );
      }
    }

    my $form;
    eval {
      my $ref = ref $class;
      $class = $ref if $ref;
      my %form_roles_by_arg = defined $args{default_form_roles_by_arg}
        ? (%{delete $args{default_form_roles_by_arg}})
        : (%default_form_roles_by_arg);
      if (defined $args{form_roles_by_arg}) {
        my %custom_form_roles_by_arg = delete $args{form_roles_by_arg};
        for my $arg (keys %custom_form_roles_by_arg) {
          $form_roles_by_arg{$arg} = $custom_form_roles_by_arg{$arg};
        }
      }
      my $process_role = delete $args{process_role} || 'SyForm::Process';
      my $no_process = delete $args{no_process};
      my $roles = delete $args{roles} || [];
      unshift @{$roles}, $process_role unless $no_process;
      unshift @{$roles}, $class, 'MooseX::Traits';
      for my $arg (keys %form_roles_by_arg) {
        if (defined $args{$arg}) {
          push @{$roles}, $form_roles_by_arg{$arg};
        }
      }
      my $form_class = delete $args{class};
      my $class_name = delete $args{class_name};

      unless ($form_class) {
        my $base_class = delete $args{base_class} || 'Moose::Object';
        my $form_metaclass = Moose::Meta::Class->create(
          $class_name ? $class_name : $class.'::__GENERATED__::'.$CLASS_SERIAL++,
          superclasses => [$base_class],
          roles => $roles,
        );
        $form_class = $form_metaclass->name;
      }

      $form = $form_class->new(
        fields => [ @field_list_args ],
      );
    };

    SyForm->throw( UnknownErrorOnCreate => [@create_args], $@ ) if ($@);

    return $form;
  }
}

1;

=encoding utf8

=head1 SYNOPSIS

  use SyForm;

  my $form = SyForm->create([
    'name' => {
      isa => 'Str',
      required => 1,
      label => 'Your name',
    },
    'age' => {
      isa => 'Int',
      label => 'Your age',
    },
  ]);

  $form->does('SyForm'); # its all roles
  $form->field('name')->does('SyForm::Field');
  $form->field('name')->does('SyForm::Field::Label');
  $form->field('name')->does('SyForm::Field::Verify');

  if (my $results = $form->process( name => 'YoCoolCopKiller', age => 13 )) {
    my $vars = $results->as_hashref;
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


