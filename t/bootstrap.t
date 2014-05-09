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
is($view->render,'<form method="POST" role="form">
<div class="form-group">
  <label for="text">My Text</label><input class="form-control" id="text" name="text" type="text">
</div>
<div class="form-group">
  <label for="textwithval">My Text with Value</label><input class="form-control" id="textwithval" name="textwithval" type="text" value="val">
</div>
<div class="form-group">
  <label for="textarea">My Textarea</label><textarea class="form-control" id="textarea" name="textarea"></textarea>
</div>
<div class="form-group">
  <label for="textareawithval">My Textarea with Value</label><textarea class="form-control" id="textareawithval" name="textareawithval">more val
and a new line</textarea>
</div>
<div class="form-group">
  <input class="form-control" id="hidden" name="hidden" type="hidden">
</div>
<div class="form-group">
  <label for="checkbox">Check the checkbox</label><input checked="checked" class="form-control" id="checkbox" name="checkbox" type="checkbox">
</div>
</form>','HTML is fine');

done_testing;