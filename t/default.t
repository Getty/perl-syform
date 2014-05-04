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
ok(!$emptyview->success,'empty process has no success');
is($emptyview->field('four')->result,4,'four gives back default value');
ok(!$emptyview->field('three')->has_result,'three has no value');
is($emptyview->field('two')->result,2,'two shows still default on empty process');

my $view = $form->process( two => 22, three => 33 );
ok($view->does('SyForm::View'),'$view does SyForm::View');
ok($view->success,'process with values has success');
is($view->field('two')->result,22,'value of two is process given');
is($view->field('three')->result,33,'value of three is process given');

done_testing;