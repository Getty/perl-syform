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
  my $field = $form->fields->Values($name);
  ok(!$field->does('SyForm::Field::Label'),'label role not loaded on field');
  ok($field->does('SyForm::Field::Process'),'process role loaded on field');
}
is($n,1,'one field');
ok($form->process( test => 12, ignored => 2 ),'Form successful processed');
is_deeply($form->results,{ test => 12 },'Result is fine');

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

done_testing;