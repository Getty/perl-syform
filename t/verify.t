#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use SyForm;

my $form = SyForm->create([
  'require' => {
    required => 1,
  },
  'integer' => {
    type => 'Int',
  },
  'reqint' => {
    required => 1,
    type => 'Int',
  },
]);

ok($form->process( require => 'something', reqint => 2 ),'process with field is true');
is($form->field('require')->result,'something','result is field with value');
ok(!$form->field('integer')->has_result,'integer field has no result');
is($form->field('reqint')->result,'2','result is field with value');
ok(!$form->process(),'process without required fields is false');
ok(!$form->field('require')->has_result,'require field has no result');
ok(!$form->field('integer')->has_result,'integer field has no result');
ok(!$form->field('reqint')->has_result,'reqint field has no result');
ok(!$form->process( require => 'something', integer => "text", reqint => 2 ),'process with string instead of integer is false');
is($form->field('require')->result,'something','result is field with value');
ok(!$form->field('integer')->has_result,'integer field has no result');
is($form->field('reqint')->result,'2','result is field with value');

done_testing;