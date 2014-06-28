package SyForm::HTML;
# ABSTRACT: HTML Form

use Moo;
use HTML::Declare ':all';
use List::MoreUtils qw( uniq );

with qw(
  MooX::Traits
  SyForm::CommonRole::GlobalHTML
  SyForm::CommonRole::EventHTML
);

our @attributes = qw(
  action
  autocomplete
  enctype
  method
  target
);

for my $attribute (@attributes) {
  has $attribute => (
    is => 'ro',
    predicate => 1,
  );
}

my @remote_attributes = uniq(
  @SyForm::CommonRole::EventHTML::attributes,
  @SyForm::CommonRole::GlobalHTML::attributes,
);

sub html_declare {
  my ( $self, @children ) = @_;
  my %html_attributes = %{$self->data_attributes};
  for my $key (@remote_attributes, @attributes) {
    my $has = 'has_'.$key;
    $html_attributes{$key} = $self->$key if $self->$has;
  }
  return FORM { %html_attributes, _ => [ @children ] };
}

1;
