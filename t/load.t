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
  SyForm::Exception::Role::WithSyFormResults
  SyForm::Exception::Role::WithSyFormValues
  SyForm::Exception::UnexpectedArgToCreate
  SyForm::Exception::UnexpectedValueOnViewFieldRoles
  SyForm::Exception::UnknownErrorOnBuildField
  SyForm::Exception::UnknownErrorOnBuildFields
  SyForm::Exception::UnknownErrorOnCreate
  SyForm::Exception::UnknownErrorOnProcess
  SyForm::Exception::UnknownErrorOnProcessValues
  SyForm::Exception::UnknownErrorOnResultsBuildView
  SyForm::Exception::UnknownErrorOnValuesBuildResults
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
  SyForm::Values::Verify
  SyForm::Verify
  SyForm::View
  SyForm::View::Errors
  SyForm::ViewField
  SyForm::ViewField::Verify
  SyForm::View::Success
  SyForm::View::Verify
)) {
  use_ok($_);
}

done_testing;