
requires 'List::MoreUtils', '0';
requires 'Moose', '2.1204';
requires 'MooseX::Role::WithOverloading', '0.13';
requires 'MooseX::Traits', '0.12';
requires 'namespace::clean', '0';
requires 'Syccess', '0';
requires 'Template::Declare', '0';
requires 'Tie::IxHash', '0';
requires 'Throwable', '0';

on test => sub {
  requires 'Test::More', '0.94';
};
