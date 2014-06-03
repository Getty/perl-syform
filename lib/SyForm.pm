package SyForm;
# ABSTRACT: Easy form management

=encoding utf8

=head1 SYNOPSIS

  use SyForm;

  my $form = SyForm->new( fields => [
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

  $view->html_render; # get HTML

=head1 DESCRIPTION

SyForm is developed for L<SyContent|https://sycontent.de/>.

Restructuring..... B<TODO>

=head1 SUPPORT

IRC

  Join #sycontent on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/SyContent/SyForm
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/SyContent/SyForm/issues

=cut

use Moose;
use Tie::IxHash;
use Carp qw( croak );
use Moose::Util::TypeConstraints;
use Module::Runtime qw( use_module );
use SyForm::Exception;
use namespace::clean -except => 'meta';

with qw(
  MooseX::Traits
  SyForm::Process
);

#######################
#
# Class Default Config
#
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
  my %default_field_args = %{$self->field_args};
  eval {
    my $fields_list = Tie::IxHash->new(@{$self->fields_list});
    for my $name ($fields_list->Keys) {
      my %field_args;
      eval {
        %field_args = ( %default_field_args, %{$fields_list->FETCH($name)} );
        $fields->Push($name, $self->new_field($name,
          %{$self->field_args}, %field_args,
        ));
      };
      SyForm->throw( UnknownErrorOnBuildField => $name, { %field_args }, $@ ) if $@;
    }
  };
  SyForm->throw( UnknownErrorOnBuildFields => $self, $@ ) if $@;
  return $fields;
}

has field_args => (
  isa => 'HashRef',
  is => 'ro',
  lazy_build => 1,
);

sub _build_field_args {
  my ( $self ) = @_;
  return {};
}

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
  return 'SyForm::Field';
}

sub new_field {
  my ( $self, $name, %field_args ) = @_;
  my $field;
  my $class = delete $field_args{class} || $self->field_class;
  my @traits = defined $field_args{roles}
    ? (@{delete $field_args{roles}}) : ();
  unshift @traits, @{$self->field_roles};
  for my $trait (@traits) {
    $class = $class->with_traits($trait);
  }
  return $class->new(
    syform => $self,
    name => $name,
    %field_args,
  );
}

sub add_traits {
  my ( $class, @traits ) = @_;
  for my $trait (@traits) {
    $class = $class->with_traits($trait);
  }
  return $class;
}

sub throw {
  my ( $class, $exception, @args ) = @_;
  SyForm::Exception->throw($exception) if scalar(@args) == 0;
  my $exception_class = 'SyForm::Exception::'.$exception;
  use_module($exception_class);
  $exception_class->throw_with_args(@args);
}

1;
