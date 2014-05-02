#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use SyForm;

my $form = SyForm->create([ 'nothing' => {} ]);
eval { $form->process()->field('nothing')->get_value_by_args(); };
my $error = $@;
isa_ok($error,'SyForm::Exception::UnexpectedCallToGetValueByArgs','$error');

my $form2 = SyForm->create([ 'wronglabel' => { label => [] } ]);
eval { $form2->field('wronglabel'); };
my $error2 = $@;
isa_ok($error2,'SyForm::Exception::ValidationFailedForTypeConstraint','$error2');

done_testing;