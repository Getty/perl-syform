
requires 'Data::Verifier', '0';
requires 'Moose', '2.1204';
requires 'MooseX::Traits', '0.12';
requires 'Tie::IxHash', '0';
requires 'namespace::autoclean', '0';

on test => sub {
  requires 'Test::More', '0.94';
};
