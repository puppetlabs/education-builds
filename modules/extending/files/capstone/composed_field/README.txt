Composed Field is an implementation of core's Field UI that allows you to split
a single field into as many sub-fields as you like.

You can configure each sub-field types and attributes as they were literally a
single field.
All the Form Controls are configurable through the Field Widget Form.

--- Features ---

* Each sub-field element type can be individually set to:

  checkbox, checkboxes, date, fieldset, file, machine_name, managed_file,
  password, password_confirm, radio, radios, select, tableselect, text_format,
  textarea, textfield, vertical_tabs, weight.

* The following field display settings are available:

  Unformatted list (Default), Fieldset, HTML list, Table, Accordion, Tabs, Dialog

--- How does it work? ---

Each field stores its value as a serialized array into the database. Each array
element represents the sub-field value.

For instance:
Say you have a field for collecting phone numbers, the phone number field
element will have these sub-fields:

Landline/Mobile (select options) | Country Code (select options) | Area Code
(select options) | Number (textfield)

The sub-fields values will be lumped together into an array like this:

array(
  [1] => 'landline', // Landline / Mobile sub-field.
  [2] => '55', // Country code  sub-field.
  [3] => '66', // Area code  sub-field.
  [4] => '3521-5555', // Number  sub-field.
);

After that the array is serialized and stored into the database as a single
value.

--- Similar Module ---

Double Field is limited to 2 sub-fields only and each sub-field only supports
textfield, select list, single checkbox and textarea types.

Composed Fields supports an unlimited number of sub-fields and each sub-field
can be set with any of the element types listed in Form Controls

--- How to use ---

Once you enable this module you will have a new "Type of data to store" called
Composed Field at the Field UI.

You should also give permission to trusted roles for entering PHP code into the
sub-field attributes that requires it so for functioning.
