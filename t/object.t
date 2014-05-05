#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use SyForm;

my $form = SyForm->create( Object => [
  'test' => {},
  'test2' => {},
]);

ok($form->does('SyForm::Object'),'$form does SyForm::Object');

my $view = $form->process(
  test => 1,
  test2 => 2,
);

ok($view->results->values->does('SyForm::Values::Object'),'$view->results->values does SyForm::Values::Object');
ok($view->results->does('SyForm::Results::Object'),'$view->results does SyForm::Results::Object');
ok($view->does('SyForm::View::Object'),'$view does SyForm::View::Object');

my $object = $view->object;

for (qw(
  has_test has_test2 test test2 meta
)) {
  ok($object->can($_),'$object can '.$_);
}
ok($object->has_test,'$object has_test');
ok($object->has_test2,'$object has_test');
is($object->test,1,'$object test value is 1');
is($object->test2,2,'$object test2 value is 2');

my $no_object_form = SyForm->create([
  'test' => {},
  'test2' => {},
]);

ok(!$no_object_form->does('SyForm::Object'),'$no_object_form does not SyForm::Object');

done_testing;