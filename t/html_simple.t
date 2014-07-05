#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use SyForm;

my $form = SyForm->new(
  fields => [
    'text' => {
      label => 'My Text',
      required => 1,
    },
    'textwithval' => {
      label => 'My Text with Value',
    },
    'textarea' => {
      label => 'My Textarea',
      input => { type => 'textarea' },
    },
    'textareawithval' => {
      label => 'My Textarea with Value',
      input => { type => 'textarea' },
    },
    'hidden' => {
      input => { type => 'hidden' },
    },
  ],
  html => {
    class => "test",
    method => "POST",
  },
  html_submit => {
    class => "submittest",
  },
);

isa_ok($form,'SyForm','$form');

my $text_field = $form->field('text');
ok($text_field->does('SyForm::FieldRole::Process'),'process role loaded on Text field');
ok($text_field->does('SyForm::FieldRole::HTML'),'html role loaded on Text field');

my $textarea_field = $form->field('textarea');
ok($textarea_field->does('SyForm::FieldRole::Process'),'process role loaded on Textarea field');
ok($textarea_field->does('SyForm::FieldRole::HTML'),'html role loaded on Textarea field');

my $hidden_field = $form->field('hidden');
ok($hidden_field->does('SyForm::FieldRole::Process'),'process role loaded on Hidden field');
ok($hidden_field->does('SyForm::FieldRole::HTML'),'html role loaded on Hidden field');

my $view = $form->process(
  textwithval => 'val',
  textareawithval => 'more val'."\n".'and a new line',
);

ok(!$view,'$view is no success');

ok($view->does('SyForm::ViewRole::HTML'),'view has html role loaded');

my $html = $view->html;
like($html,qr{<form}i,'Starting form tag found');
like($html,qr{method="POST"}i,'Starting method found');
like($html,qr{for="text"}i,'for text is found');
like($html,qr{for="textwithval"}i,'for textwithval is found');
like($html,qr{for="textarea"}i,'for textarea is found');
like($html,qr{for="textareawithval"}i,'for textareawithval is found');
like($html,qr{type="submit"}i,'Submit button found');

done_testing;
