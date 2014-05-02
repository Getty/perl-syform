#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use_ok('SyForm');
use_ok('SyForm::Exception::Role::WithSyForm');
use_ok('SyForm::Exception::Role::WithSyFormField');
use_ok('SyForm::Exception::UnexpectedCallToGetValueByArgs');
use_ok('SyForm::Exception::UnknownErrorOnBuildFields');
use_ok('SyForm::Exception::UnknownErrorOnCreate');
use_ok('SyForm::Exception::UnknownErrorOnProcess');
use_ok('SyForm::Field');
use_ok('SyForm::Field::Default');
use_ok('SyForm::Field::HTML');
use_ok('SyForm::Field::Label');
use_ok('SyForm::Field::Process');
#use_ok('SyForm::Field::Readonly
use_ok('SyForm::Fields');
use_ok('SyForm::Field::Verify');
use_ok('SyForm::Meta::Attribute::Field');
use_ok('SyForm::Process');
use_ok('SyForm::Results');
use_ok('SyForm::Results::Success');
use_ok('SyForm::Results::Verify');
use_ok('SyForm::Values');
use_ok('SyForm::Verify');


done_testing;