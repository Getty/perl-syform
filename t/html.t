#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use SyForm;

my $form = SyForm->create([
  'text' => {
    label => 'My Text',
    html => 'text',
  },
  'textarea' => {
    label => 'My Textarea',
    html => 'textarea',
  },
  'hidden' => {
    html => 'hidden',
  },
  'readonly' => {
    label => 'My Text',
    html => 'text',
#    readonly => 1,
  },
]);

ok($form->does('SyForm'),'$form does SyForm');

my $text_field = $form->field('text');
ok($text_field->does('SyForm::Field::Label'),'label role loaded on Text field');
ok($text_field->does('SyForm::Field::Process'),'process role loaded on Text field');
ok($text_field->does('SyForm::Field::HTML'),'html role loaded on Text field');
#ok(!$text_field->does('SyForm::Field::Readonly'),'readonly role not loaded on Text field');
is($text_field->html,'text','Text field gives back correct html');

my $textarea_field = $form->field('textarea');
ok($textarea_field->does('SyForm::Field::Label'),'label role loaded on Textarea field');
ok($textarea_field->does('SyForm::Field::Process'),'process role loaded on Textarea field');
ok($textarea_field->does('SyForm::Field::HTML'),'html role loaded on Textarea field');
#ok(!$textarea_field->does('SyForm::Field::Readonly'),'readonly role not loaded on Textarea field');
is($textarea_field->html,'textarea','Textarea field gives back correct html');

my $hidden_field = $form->field('hidden');
ok(!$hidden_field->does('SyForm::Field::Label'),'label role not loaded on Hidden field');
ok($hidden_field->does('SyForm::Field::Process'),'process role loaded on Hidden field');
ok($hidden_field->does('SyForm::Field::HTML'),'html role loaded on Hidden field');
#ok(!$hidden_field->does('SyForm::Field::Readonly'),'readonly role not loaded on Hidden field');
is($hidden_field->html,'hidden','Hidden field gives back correct html');

my $readonly_field = $form->field('readonly');
ok($readonly_field->does('SyForm::Field::Label'),'label role loaded on Readonly field');
ok($readonly_field->does('SyForm::Field::Process'),'process role loaded on Readonly field');
ok($readonly_field->does('SyForm::Field::HTML'),'html role loaded on Readonly field');
#ok($readonly_field->does('SyForm::Field::Readonly'),'readonly role loaded on Readonly field');
is($readonly_field->html,'text','Readonly field gives back correct html');

done_testing;