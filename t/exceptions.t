#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use SyForm;

my $form2 = SyForm->create([ 'wronglabel' => { label => [] } ]);
eval { $form2->field('wronglabel'); };
my $error2 = $@;
isa_ok($error2,'SyForm::Exception::ValidationFailedForTypeConstraint','$error2');
is($error2->field_name,'wronglabel','$error2->field_name is correct');

eval { SyForm->create({},[]) };
my $error3 = $@;
isa_ok($error3,'SyForm::Exception::UnexpectedArgToCreate','$error3');
is($error3->error_ref,'HASH','$error3->error_ref is correct');

eval { my $form4 = SyForm->create([ test => { html => 'text', label => 'bla' } ], need_submit => 1 ) };
my $error4 = $@;
isa_ok($error4,'SyForm::Exception::NeedSubmitRequiresFormName','$error4');
ok($error4->syform->does('SyForm'),'$error4->syform is a syform');

done_testing;