#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use SyForm;

my $form = SyForm->create([ 'test' => {} ]);
eval { $form->process()->field('test')->get_value_by_args(); };
my $error = $@;
isa_ok($error,'SyForm::Exception::UnexpectedCallToGetValueByArgs','$error');

done_testing;