#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

for (qw(
  SyForm
  SyForm::Bootstrap
  SyForm::Class
  SyForm::Exception
  SyForm::Exception::NeedSubmitRequiresFormName
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
  SyForm::HTML
  SyForm::Label
  SyForm::Meta::Attribute::Field
  SyForm::Object
  SyForm::Process
  SyForm::Results
  SyForm::Results::Object
  SyForm::Results::Success
  SyForm::Results::Verify
  SyForm::Values
  SyForm::Values::Object
  SyForm::Values::Verify
  SyForm::Verify
  SyForm::View
  SyForm::View::Bootstrap
  SyForm::ViewField
  SyForm::ViewField::Bootstrap
  SyForm::ViewField::HTML
  SyForm::ViewField::Label
  SyForm::ViewField::Verify
  SyForm::View::HTML
  SyForm::View::Object
  SyForm::View::Success
  SyForm::View::Verify
)) {
  use_ok($_);
}

done_testing;