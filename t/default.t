#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use SyForm;

my $form = SyForm->create([
  'one' => {
    default => 1,
  },
  'two' => {
    label => 'two',
    default => 2,
  },
  'three' => {
    default => 3,
    required => 1,
  },
  'four' => {
    label => 'four',
    default => 4,
    required => 1,
  },
]);

my $emptyview = $form->process;
ok($emptyview->does('SyForm::View'),'$emptyview does SyForm::View');
ok($emptyview->success,'empty process has success through default values');

my $view = $form->process( two => 22, three => 33 );
ok($view->does('SyForm::View'),'$view does SyForm::View');
ok($view->success,'process with values has success');
is($view->field('two')->result,22,'value of two is process given');
is($view->field('three')->result,33,'value of three is process given');

done_testing;