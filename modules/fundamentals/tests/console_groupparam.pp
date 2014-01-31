fundamentals::console::groupparam { 'activemq_heap_mb':
  group => 'puppet_master',
  class => 'pe_mcollective::role::master',
  param => 'activemq_heap_mb',
  value => '1024',
}
