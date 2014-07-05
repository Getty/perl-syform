package SyForm::ViewField::LabelHTML;

use Moo;
use List::MoreUtils qw( uniq );
use HTML::Declare ':all';

with qw(
  MooX::Traits
  SyForm::CommonRole::GlobalHTML
);

has label => (
  is => 'ro',
  required => 1,
);

my @own_attributes = qw( for );

for my $attribute (@own_attributes, qw( errors )) {
  has $attribute => (
    is => 'ro',
    predicate => 1,
  );
}

has with_errors => (
  is => 'lazy',
);

sub _build_with_errors {
  my ( $self ) = @_;
  return 1;
}

has html_declare => (
  is => 'lazy',
);

sub _build_html_declare {
  my ( $self ) = @_;
  my %html_attributes = %{$self->data_attributes};
  for my $key (@SyForm::CommonRole::GlobalHTML::attributes) {
    my $has = 'has_'.$key;
    $html_attributes{$key} = $self->$key if $self->$has;
  }
  for my $key (@own_attributes) {
    my $has = 'has_'.$key;
    $html_attributes{$key} = $self->$key if $self->$has;
  }
  $html_attributes{_} = [
    $self->label,
    ( $self->with_errors && $self->has_errors ) ? (
      map { EM { _ => $_->message } } @{$self->errors}
    ) : (),
  ],
  return LABEL { %html_attributes };
}

1;
