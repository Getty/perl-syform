#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use SyForm;

my $form = SyForm->create( Bootstrap => [
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
  'checkbox' => {
    label => 'Check the checkbox',
    html => 'checkbox',
  },
#   'readonly' => {
#     label => 'My Text',
#     html => 'text',
#     readonly => 1,
#   },
]);

ok($form->does('SyForm::Bootstrap'),'$form does SyForm::Bootstrap');

ok(my $view = $form->process(
  textwithval => 'val',
  textareawithval => 'more val'."\n".'and a new line',
  checkbox => 1,
),'$view is success');

ok($view->does('SyForm::View::Bootstrap'),'$view has Bootstrap role loaded');

my $html = $view->bootstrap_render;

ok(length($html),'There is some output ;)');

done_testing;