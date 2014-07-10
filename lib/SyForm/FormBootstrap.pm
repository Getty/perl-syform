package SyForm::FormBootstrap;
# ABSTRACT: Bootstrap Form

use Moo;
use HTML::Declare ':all';
use Safe::Isa;
use SyForm::Util::HTML;

with qw(
  MooX::Traits
);

our @attributes = qw();

for my $attribute (@attributes) {
  has $attribute => (
    is => 'ro',
    predicate => 1,
  );
}

has syform_formhtml => (
  is => 'ro',
  required => 1,
  handles => [qw(
    no_submit
  )],
);

=attr layout

L<http://getbootstrap.com/css/#forms>

=cut

has layout => (
  is => 'lazy',
);

sub _build_layout {
  my ( $self ) = @_;
  return 'basic';
}

=attr submit_style

L<http://getbootstrap.com/css/#buttons-options>

=cut

has submit_style => (
  is => 'lazy',
);

sub _build_submit_style {
  my ( $self ) = @_;
  return 'primary';
}

=attr submit_size

L<http://getbootstrap.com/css/#buttons-sizes>

=cut

has submit_size => (
  is => 'ro',
  predicate => 1,
);

=attr submit_block

L<http://getbootstrap.com/css/#buttons-sizes>

=cut

has submit_block => (
  is => 'lazy',
);

sub _build_submit_block {
  my ( $self ) = @_;
  return 0;
}

=attr submit_active

L<http://getbootstrap.com/css/#buttons-active>

=cut

has submit_active => (
  is => 'lazy',
);

sub _build_submit_active {
  my ( $self ) = @_;
  return 0;
}

has submit_html_declare => (
  is => 'lazy',
);

sub _build_submit_html_declare {
  my ( $self ) = @_;
  my $html_submit = $self->syform_formhtml->submit->html_declare;
  my @classes = "btn";
  push @classes, "btn-".$self->submit_style;
  push @classes, "btn-".$self->submit_size if $self->has_submit_size;
  push @classes, "btn-block" if $self->submit_block;
  push @classes, "active" if $self->submit_active;
  return put_html_attr(
    $html_submit,
    class => join(" ",@classes),
    role => 'button',
  );
}

has children => (
  is => 'ro',
  predicate => 1,
);

has html_declare => (
  is => 'lazy',
);

sub _build_html_declare {
  my ( $self ) = @_;
  my @submit = $self->no_submit
    ? () : ( $self->submit_html_declare );
  return FORM {
    %{$self->syform_formhtml->html_attributes},
    _ => [
      $self->syform_formhtml->has_children ? ( map { $_->html_declare } @{$self->syform_formhtml->children} ) : (),
      @submit,
    ],
  };
}

has html_declare_children => (
  is => 'lazy',
);

sub _build_html_declare_children {
  my ( $self ) = @_;
  return unless $self->has_children;
  my @children;
  for my $child (@{$self->children}) {
    if (!ref $child || $child->$_isa('HTML::Declare')) {
      push @children, $child;
    } else {
      push @children, $child->html_declare;
    }
  }
  return;
}

1;
