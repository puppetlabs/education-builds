## Classroom automation script - EC2

The ec2classroom.rc script sets up classroom VMs.

The configuration of each class is described in the YAML files in ./courses

If a course requires a VM per student, there should be a key matching "student"
with the following sub-keys:

"ami" is the id of the AMI, e.g. "ami-2051b840"
"type" is the EC2 instance type, e.g. "t2.large"
"key_name" is the public ssh key to use
"security_group_ids" is an array of the AWS security groups to apply.

If a course only requires a single VM, such as the puppetfactory based courses,
create a key with the name "master".

For courses that need both master and student VMs, create both keys.

## VM details

The script takes a single argument of a JSON formatted string.
It expects the following:
"title" is the title of the course, e.g. "Infrastructure Design"
"course_id" is the Event ID, e.g. "IFD1MAR16"
"start" is the start date of the course
"end" is the end date of the course
"students" is a hash of students emails keyed on student name. e.g. 
  { 
    "foo":"foo@bar.com",
    "bar":"bar@baz.net",
    "baz":"baz@foo.bar",
  }

