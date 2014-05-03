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

ok($form->does('SyForm'),'$form does SyForm');
my $results = $form->process_results( require => 'something', reqint => 2 );
ok($results->does('SyForm::Results'),'$results does SyForm::Results');
ok($results->does('SyForm::Results::Success'),'$results does SyForm::Results::Success');
ok($results->does('SyForm::Results::Verify'),'$results does SyForm::Results::Verify');
ok($results->success,'$results is a success');
is($results->require,'something','result is field with value');
ok(!$results->has_integer,'integer field has no result');
is($results->reqint,'2','result is field with value');
my $emptyresults = $form->process_results();
ok(!$emptyresults->success,'$emptyresults is no success');
ok(!$emptyresults->has_require,'require field has no result');
ok(!$emptyresults->has_integer,'integer field has no result');
ok(!$emptyresults->has_reqint,'reqint field has no result');
my $badresults = $form->process_results( require => 'something', integer => "text", reqint => 2 );
ok(!$badresults->success,'$badresults is no success');
is($badresults->require,'something','result is field with value');
ok(!$badresults->has_integer,'integer field has no result');
is($badresults->reqint,'2','result is field with value');

done_testing;