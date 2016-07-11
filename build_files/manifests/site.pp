node default {
  include bootstrap::role::training
}
node /student/ {
  include bootstrap::role::student
}
node /learn/ {
  include bootstrap::role::learning
}
node /master/ {
  include bootstrap::role::master
}
node /lms/ {
  include bootstrap::role::lms_vm
}
