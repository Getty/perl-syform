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
  'textwithval' => {
    label => 'My Text with Value',
    html => 'text',
  },
  'textarea' => {
    label => 'My Textarea',
    html => 'textarea',
  },
  'textareawithval' => {
    label => 'My Textarea with Value',
    html => 'textarea',
  },
  'hidden' => {
    html => 'hidden',
  },
#   'readonly' => {
#     label => 'My Text',
#     html => 'text',
#     readonly => 1,
#   },
]);

ok($form->does('SyForm'),'$form does SyForm');

my $text_field = $form->field('text');
ok($text_field->does('SyForm::Field::Label'),'label role loaded on Text field');
ok($text_field->does('SyForm::Field::Process'),'process role loaded on Text field');
ok($text_field->does('SyForm::Field::HTML'),'html role loaded on Text field');
is($text_field->html,'text','Text field gives back correct html');

my $textarea_field = $form->field('textarea');
ok($textarea_field->does('SyForm::Field::Label'),'label role loaded on Textarea field');
ok($textarea_field->does('SyForm::Field::Process'),'process role loaded on Textarea field');
ok($textarea_field->does('SyForm::Field::HTML'),'html role loaded on Textarea field');
is($textarea_field->html,'textarea','Textarea field gives back correct html');

my $hidden_field = $form->field('hidden');
ok(!$hidden_field->does('SyForm::Field::Label'),'label role not loaded on Hidden field');
ok($hidden_field->does('SyForm::Field::Process'),'process role loaded on Hidden field');
ok($hidden_field->does('SyForm::Field::HTML'),'html role loaded on Hidden field');
is($hidden_field->html,'hidden','Hidden field gives back correct html');

# my $readonly_field = $form->field('readonly');
# ok($readonly_field->does('SyForm::Field::Label'),'label role loaded on Readonly field');
# ok($readonly_field->does('SyForm::Field::Process'),'process role loaded on Readonly field');
# ok($readonly_field->does('SyForm::Field::HTML'),'html role loaded on Readonly field');
# is($readonly_field->html,'text','Readonly field gives back correct html');

ok(my $view = $form->process(
  textwithval => 'val',
  textareawithval => 'more val'."\n".'and a new line',
),'$view is success');

ok($view->does('SyForm::View::HTML'),'view has html role loaded');
is($view->render,'<form>
<input name="text" type="text">
<input name="textwithval" type="text" value="val">
<textarea name="textarea"></textarea>
<textarea name="textareawithval">more val
and a new line</textarea>
<input name="hidden" type="hidden">
</form>','HTML is fine');

done_testing;