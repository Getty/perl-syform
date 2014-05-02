#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

for (qw(
  SyForm
  SyForm::Exception
  SyForm::Exception::Role::WithOriginalError
  SyForm::Exception::Role::WithSyForm
  SyForm::Exception::Role::WithSyFormField
  SyForm::Exception::UnexpectedCallToGetValueByArgs
  SyForm::Exception::UnknownErrorOnBuildField
  SyForm::Exception::UnknownErrorOnBuildFields
  SyForm::Exception::UnknownErrorOnCreate
  SyForm::Exception::UnknownErrorOnProcess
  SyForm::Exception::ValidationFailedForTypeConstraint
  SyForm::Field
  SyForm::Field::Default
  SyForm::Field::HTML
  SyForm::Field::Label
  SyForm::Field::Process
  SyForm::Fields
  SyForm::Field::Verify
  SyForm::Meta::Attribute::Field
  SyForm::Process
  SyForm::Results
  SyForm::Results::Success
  SyForm::Results::Verify
  SyForm::Values
  SyForm::Verify
)) {
  use_ok($_);
}

done_testing;