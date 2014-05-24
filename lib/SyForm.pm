package SyForm;
# ABSTRACT: Easy role driven form management

=encoding utf8

=head1 SYNOPSIS

  use SyForm;

  my $form = SyForm->create([
    'username' => {
      required => 1,
      label => 'Your name',
      html => 'text',
    },
    'age' => {
      decimal => 1,
      label => 'Your age',
      html => 'text',
    },
    'unchecked' => {
      label => 'Unchecked',
      html => 'textarea',
    },
  ]);

  $form->does('SyForm'); # its all roles
  $form->field('username')->does('SyForm::Field');
  $form->field('username')->does('SyForm::Field::Label');
  $form->field('username')->does('SyForm::Field::Verify');

  # Roles are only automatically loaded on requirement
  !$form->field('unchecked')->does('SyForm::Field::Verify');

  my $view = $form->process( username => 'YoCoolCopKiller', age => 13 );

  # or ...
  # $values = $form->process_values(%args);
  # my $value = $values->value;
  # !$values->can('success'); # values are only the input
  # $results = $form->process_results(%args);
  # my $result = $results->get_result('username');
  # my $value = $results->values->get_value('username');
  # my $success = $result->success # result is after check

  for my $field_name (@{$view->field_names}) {
    my $input_value = $view->field($field_name)->value;
    if ($view->success) {
      my $verified_result = $view->field($field_name)->result;  
    } else {
      # result is filled for all valid fields, even on invalid form
      my $verified_result_if_exist = $view->field($field_name)->result;
    }
    # for access to the main SyForm::Field of the view field
    my $syform_field = $view->field($field_name)->field;
  }

  $view->render; # get HTML

  my $bs_form = SyForm->create( Bootstrap => [
    # form fields like above
  ]);

  $bs_form->render; # Bootstrap HTML

=head1 DESCRIPTION

SyForm is developed for L<SyContent|https://sycontent.de/>.

L<SyForm> has many L<SyForm::Field>. You get a form object with calling
B<create([@fields], %form_args)> on L<SyForm>.

With L<SyForm::Process> (automatically added) you can give it L<process_args>
via calling of L<process(%args)> on your form object that you get from the
create.

This call to process creates internally a L<SyForm::Values> out of the process
args together with the help of the fields. Those again use this to produce a
L<SyForm::Results> with the final results of the process.

Those end up in a L<SyForm::View> together with a L<SyForm::ViewField> for
every L<SyForm::Field> that is used in the process flow. The view field allows
easy access to the L<SyForm::Values> values, the L<SyForm::Results> results
and the actually L<SyForm::Field> definition, to get a complete access of
all variables in the rendering.

For validation L<SyForm> implements L<Syccess> and so all of the
directives available there are available in L<SyForm>. A complete list 
can be found at L<SyForm::Field::Verify>.

=head1 SUPPORT

IRC

  Join #sycontent on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/SyContent/SyForm
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/SyContent/SyForm/issues

=cut

use Moose::Role;
use Tie::IxHash;
use Carp qw( croak );
use Moose::Util qw( apply_all_roles );
use Moose::Util::TypeConstraints;
use Module::Runtime qw( use_module );

role_type 'SyForm::Field';
role_type 'SyForm::Field::Verify';
role_type 'SyForm::Values';
role_type 'SyForm::Results';
role_type 'SyForm::View';
role_type 'SyForm::ViewField';

use SyForm::Exception;
use namespace::clean -except => 'meta';

require SyForm::Field::Verify;

with qw(
  MooseX::Traits
);

#######################
#
# Class Default Config
#
#######################

our $default_object_class = 'Moose::Object';

our %default_form_roles_by_arg = (
  label => 'SyForm::Label',
  object => 'SyForm::Object',
  need_submit => 'SyForm::HTML',
);

our %default_field_roles_by_arg = (
  default => 'SyForm::Field::Default',
  readonly => 'SyForm::Field::Readonly',
  (map { $_ => 'SyForm::Field::Verify' } @SyForm::Field::Verify::validation_class_directives),
  html => 'SyForm::Field::HTML',
  label => 'SyForm::Field::Label',
);

our %default_form_roles_by_field_arg = (
  (map { $_ => 'SyForm::Verify' } grep {
    $default_field_roles_by_arg{$_} eq 'SyForm::Field::Verify'
  } keys %default_field_roles_by_arg),
  html => 'SyForm::HTML',
);

#######################

has name => (
  isa => 'Str',
  is => 'ro',
  predicate => 'has_name',
);

has fields_list => (
  isa => 'ArrayRef[Str|HashRef]',
  is => 'ro',
  init_arg => 'fields',
  required => 1,
);

has fields => (
  isa => 'Tie::IxHash',
  is => 'ro',
  init_arg => undef,
  lazy_build => 1,
);
sub field { shift->fields->FETCH(@_) }

sub _build_fields {
  my ( $self ) = @_;
  my $fields = Tie::IxHash->new;
  eval {
    my $fields_list = Tie::IxHash->new(@{$self->fields_list});
    for my $name ($fields_list->Keys) {
      my %field_args;
      eval {
        %field_args = %{$fields_list->FETCH($name)};
        $fields->Push($name, $self->create_field($name,
          %{$self->field_args}, %field_args,
        ));
      };
      SyForm->throw( UnknownErrorOnBuildField => $name, { %field_args }, $@ ) if $@;
    }
  };
  SyForm->throw( UnknownErrorOnBuildFields => $self, $@ ) if $@;
  return $fields;
}

sub create_field {
  my ( $self, $name, %field_args ) = @_;
  my $field;
  my $class = delete $field_args{class} || $self->field_class;
  my $traits = delete $field_args{roles} || [];
  push @{$traits}, @{$self->field_roles};
  for my $arg (keys %default_field_roles_by_arg) {
    if (exists $field_args{$arg}) {
      push @{$traits}, $default_field_roles_by_arg{$arg};
    }
  }
  return $class->new_with_traits(
    syform => $self,
    traits => $traits,
    name => $name,
    %field_args,
  );
}

has field_args => (
  isa => 'HashRef',
  is => 'ro',
  lazy => 1,
  default => sub {{}},
);

has object_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);
sub _build_object_class { $default_object_class }

has field_roles => (
  isa => 'ArrayRef[Str]',
  is => 'ro',
  lazy_build => 1,
);

sub _build_field_roles {
  my ( $self ) = @_;
  return [];
}

has field_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);

sub _build_field_class {
  my ( $self ) = @_;
  return $self->_field_metaclass->name;
}

has field_object_class => (
  isa => 'Str',
  is => 'ro',
  lazy_build => 1,
);
sub _build_field_object_class { $_[0]->object_class }

has _field_metaclass => (
  isa => 'Moose::Meta::Class',
  is => 'ro',
  lazy_build => 1,
);

sub _build__field_metaclass {
  my ( $self ) = @_;
  return Moose::Meta::Class->create(
    (ref $self).'::Field',
    superclasses => [$self->field_object_class],
    roles => [ 'SyForm::Field' ],
  )
}

sub throw {
  my ( $class, $exception, @args ) = @_;
  SyForm::Exception->throw($exception) if scalar(@args) == 0;
  my $exception_class = 'SyForm::Exception::'.$exception;
  use_module($exception_class);
  $exception_class->throw_with_args(@args);
}

{
  my $CLASS_SERIAL = 0;
  sub create {
    my @create_args = @_;
    my ( $class, @all_args ) = @_;
    my $ref = ref $class;
    $class = $ref if $ref;
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
      if (defined $args{roles}) {
        push @roles, @{delete $args{roles}};
      }
      unshift @roles, $process_role unless $no_process;
      unshift @roles, $class;
      for my $arg (keys %form_roles_by_arg) {
        if (defined $args{$arg}) {
          push @roles, $form_roles_by_arg{$arg};
        }
      }
      my $fields_list = Tie::IxHash->new(@field_list_args);
      for my $name ($fields_list->Keys) {
        my %field_args = %{$fields_list->FETCH($name)};
        for my $arg (keys %default_form_roles_by_field_arg) {
          if (defined $field_args{$arg}) {
            push @roles, $default_form_roles_by_field_arg{$arg};
          }
        }
      }
      my $form_class = delete $args{class};
      my $class_name = delete $args{class_name};
      my $field_roles = delete $args{field_roles} || [];
      my $field_class = delete $args{field_class};
      my $form_default_object_class = delete $args{default_object_class};

      unless ($form_class) {
        my $object_class = delete $args{object_class} ||
          $form_default_object_class || $default_object_class;
        my $form_metaclass = Moose::Meta::Class->create(
          $class_name ? $class_name : $class.'::__GENERATED__::'.$CLASS_SERIAL++,
          superclasses => [ $object_class ],
          roles => [ @roles ],
        );
        $form_class = $form_metaclass->name;
      }

      $form = $form_class->new(
        $form_default_object_class
          ? ( object_class => $form_default_object_class ) : (),
        scalar @{$field_roles} ? ( field_roles => $field_roles ) : (),
        fields => [ @field_list_args ],
        %args,
      );
    };

    SyForm->throw( UnknownErrorOnCreate => [@create_args], $@ ) if ($@);

    return $form;
  }
}

1;
