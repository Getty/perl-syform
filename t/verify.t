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
    decimal => 1,
  },
  'reqint' => {
    required => 1,
  },
  'trimmed' => {
    filters => 'trim',
  },
]);

ok($form->does('SyForm'),'$form does SyForm');
my $results = $form->process_results( require => 'something', reqint => 2 );
ok($results ? 1 : 0,'$results is bool success');
ok($results->does('SyForm::Results'),'$results does SyForm::Results');
ok($results->does('SyForm::Results::Success'),'$results does SyForm::Results::Success');
ok($results->does('SyForm::Results::Verify'),'$results does SyForm::Results::Verify');
ok($results->success,'$results is a success');
is($results->get_result('require'),'something','result is field with value');
ok(!$results->has_result('integer'),'integer field has no result');
is($results->get_result('reqint'),'2','result is field with value');
my $emptyresults = $form->process_results();
ok($emptyresults ? 0 : 1,'$emptyresults is no bool success');
ok(!$emptyresults->has_result('require'),'require field has no result');
ok(!$emptyresults->has_result('integer'),'integer field has no result');
ok(!$emptyresults->has_result('reqint'),'reqint field has no result');
my $badresults = $form->process_results(
  require => 'something',
  integer => "text",
  reqint => 2,
  trimmed => '  Some text    ',
);
my @errors = $badresults->validation_class->get_errors;
is(scalar @errors,1,'$badresults errorlist has one error');
is($badresults->error_count,1,'$badresults error_count is 1');
ok(!$badresults->success,'$badresults is no success');
is($badresults->get_result('require'),'something','result is field with value');
ok(!$badresults->has_result('integer'),'integer field has no result');
is($badresults->get_result('reqint'),'2','reqint has valid value');
is($badresults->get_result('trimmed'),'Some text','trimmed has trimmed value');

done_testing;