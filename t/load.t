#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

for (qw(
  SyForm
  SyForm::CommonRole::EventHTML
  SyForm::CommonRole::GlobalHTML
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
  SyForm::Field::InputHTML
  SyForm::FieldRole::Default
  SyForm::FieldRole::HTML
  SyForm::FieldRole::Process
  SyForm::FieldRole::Verify
  SyForm::HTML
  SyForm::Results
  SyForm::ResultsRole::Success
  SyForm::ResultsRole::Verify
  SyForm::Role::HTML
  SyForm::Role::Label
  SyForm::Role::Process
  SyForm::Role::Verify
  SyForm::Util::HTML
  SyForm::Values
  SyForm::ValuesRole::Verify
  SyForm::View
  SyForm::ViewField
  SyForm::ViewFieldRole::Verify
  SyForm::ViewRole::HTML
  SyForm::ViewRole::Success
  SyForm::ViewRole::Verify
)) {
  use_ok($_);
}

done_testing;
