
requires 'Moo', '0';
requires 'MooX::Traits', '0';
requires 'Module::Load::Conditional', '0';
requires 'Module::Runtime', '0';
requires 'Syccess', '0';
requires 'HTML::Declare', '0';
requires 'Throwable', '0';

on test => sub {
  requires 'Test::More', '0.94';
};
