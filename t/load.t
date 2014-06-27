#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

for (qw(
  SyForm
  SyForm::Exception
  SyForm::Exception::OddNumberOfArgsOnCreateValuesByArgs
  SyForm::Exception::Role::WithOriginalError
  SyForm::Exception::Role::WithSyForm
  SyForm::Exception::Role::WithSyFormField
  SyForm::Exception::Role::WithSyFormResults
  SyForm::Exception::Role::WithSyFormValues
  SyForm::Exception::UnknownArgOnCreateValuesByArgs
  SyForm::Exception::UnknownErrorOnBuildFields
  SyForm::Exception::UnknownErrorOnCreateValuesByArgs
  SyForm::Exception::UnknownErrorOnProcess
  SyForm::Exception::UnknownErrorOnResultsBuildView
  SyForm::Exception::UnknownErrorOnValuesBuildResults
  SyForm::Field
  SyForm::FieldRole::Default
  SyForm::FieldRole::Process
  SyForm::FieldRole::Verify
  SyForm::Results
  SyForm::ResultsRole::Success
  SyForm::ResultsRole::Verify
  SyForm::Role::Label
  SyForm::Role::Process
  SyForm::Role::Verify
  SyForm::Values
  SyForm::ValuesRole::Verify
  SyForm::View
  SyForm::ViewField
  SyForm::ViewFieldRole::Verify
  SyForm::ViewRole::Success
  SyForm::ViewRole::Verify
)) {
  use_ok($_);
}

done_testing;
