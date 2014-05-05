package SyForm::Fields;
# ABSTRACT: Role for SyForm::Values and SyForm::Results holding the fields

use Moose::Role;
################ TODO
# use overload
#   q{%{}} => sub { use DDP; p($_[0]); 
#     $_[0]->as_hashref },
#   q{@{}} => sub {[ map {
#     $_[0]->as_hashref->{$_}
#   } keys %{$_[0]->as_hashref} ]};
use namespace::clean -except => 'meta';

requires 'as_hashref';

has field_names => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  required => 1,
);

1;