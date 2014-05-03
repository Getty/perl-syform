#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use SyForm;

my $form = SyForm->create([
  'test' => {},
]);

ok($form->does('SyForm'),'$form does SyForm');
my $n = 0;
for my $name ($form->fields->Keys) {
  $n++;
  my $field = $form->field($name);
  ok(!$field->does('SyForm::Field::Label'),'label role not loaded on field');
  ok($field->does('SyForm::Field::Process'),'process role loaded on field');
}
is($n,1,'one field');
my $emptyview = $form->process();
ok($emptyview->does('SyForm::View'),'$emptyview does SyForm::View');
my $emptyresult = $emptyview->results();
ok($emptyresult->does('SyForm::Results'),'Result is SyForm::Results');
ok(!$emptyresult->has_test,'Result has no value for test');
is_deeply($emptyresult->as_hashref,{},'Result hash is empty');
my $result = $form->process_results( test => 12, ignored => 2 );
ok($result->does('SyForm::Results'),'Result is SyForm::Results');
is($result->test,12,'Result of test is fine');
is_deeply($result->as_hashref,{ test => 12 },'Result as hash is fine');
# TODO
# my %result_hash = %{$result};
# is_deeply({ %result_hash },{ test => 12 },'Result as hash is fine');

my $form2 = SyForm->create([
  'test' => {},
  'test2' => {
    label => 'Test Label',
  },
  'test3' => {
    label => 'Test Label',
    no_process => 1,
  },
  'test4' => {
    no_process => 1,
  },
]);

my $test_field = $form2->field('test');
ok(!$test_field->does('SyForm::Field::Label'),'label role not loaded on 1st field');
ok($test_field->does('SyForm::Field::Process'),'process role loaded on 1st field');
my $test2_field = $form2->field('test2');
ok($test2_field->does('SyForm::Field::Label'),'label role loaded on 2nd field');
ok($test2_field->does('SyForm::Field::Process'),'process role loaded on 2nd field');
my $test3_field = $form2->field('test3');
ok($test3_field->does('SyForm::Field::Label'),'label role loaded on 3rd field');
ok(!$test3_field->does('SyForm::Field::Process'),'process role loaded on 3rd field');
my $test4_field = $form2->field('test4');
ok(!$test4_field->does('SyForm::Field::Label'),'label role not loaded on 4rd field');
ok(!$test4_field->does('SyForm::Field::Process'),'process role loaded on 4rd field');
my $form2view = $form2->process( test2 => 'lalala' );
ok($form2view->does('SyForm::View'),'$form2view does SyForm::View');
my $result2 = $form2view->results();
ok($result2->has_test2,'Has a test2 result value');
is($result2->test2,'lalala','Expected test2 result value');
ok(!$result2->has_test,'Has no test result value');
ok($result2->does('SyForm::Results'),'Result is SyForm::Results');
is_deeply($result2->field_names,[qw(
  test test2
)],'Field names are in correct order');

my $result3 = SyForm->create([
  'test' => {},
  'test2' => {
    label => 'Test Label',
  },
  'test3' => {},
  'test4' => {
    no_process => 1,
  },
  'test5' => {},
])->process_results();
is_deeply($result3->field_names,[qw(
  test test2 test3 test5
)],'Other field names are also in correct order');

done_testing;