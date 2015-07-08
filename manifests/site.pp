node default {
  include bootstrap::role::training
}
node /student/ {
  include bootstrap::role::student
}
node /learn/ {
  include bootstrap::role::learning
}
node /puppetfactory/ {
  include bootstrap::role::puppetfactory
}
node /lms/ {
  include bootstrap::role::lms
}
