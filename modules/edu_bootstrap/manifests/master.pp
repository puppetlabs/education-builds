class edu_bootstrap::master {

  $student_array = split($::students, ',')
  edu_bootstrap::user { $student_array: }

}
