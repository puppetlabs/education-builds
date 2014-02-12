class fundamentals::console::patch {
  # This would be much nicer with a diff type....
  file_line { 'live management select none':
    path  => '/opt/puppet/share/live-management/public/javascripts/node.js',
    line  => "              node.set('isSelected', false);",
    match => '^\s*node.set\(\'isSelected',
  }
}