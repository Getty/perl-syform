#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

for (qw(
  SyForm
  SyForm::Class
  SyForm::Exception
  SyForm::Exception::Role::WithCreateArgs
  SyForm::Exception::Role::WithOriginalError
  SyForm::Exception::Role::WithSyForm
  SyForm::Exception::Role::WithSyFormField
  SyForm::Exception::UnexpectedArgToCreate
  SyForm::Exception::UnexpectedValueOnViewFieldRoles
  SyForm::Exception::UnknownErrorOnBuildField
  SyForm::Exception::UnknownErrorOnBuildFields
  SyForm::Exception::UnknownErrorOnCreate
  SyForm::Exception::UnknownErrorOnProcess
  SyForm::Exception::UnknownErrorOnProcessResults
  SyForm::Exception::UnknownErrorOnProcessValues
  SyForm::Exception::UnknownErrorOnProcessView
  SyForm::Exception::ValidationFailedForTypeConstraint
  SyForm::Field
  SyForm::Field::Default
  SyForm::Field::HTML
  SyForm::Field::Label
  SyForm::Field::Process

  SyForm::Fields
  SyForm::Field::Verify
  SyForm::Label
  SyForm::Meta::Attribute::Field
  SyForm::Process
  SyForm::Results
  SyForm::Results::Success
  SyForm::Results::Verify
  SyForm::Values
  SyForm::Verify
  SyForm::View
  SyForm::ViewField
  SyForm::View::Success
  SyForm::View::Verify
)) {
  use_ok($_);
}

done_testing;