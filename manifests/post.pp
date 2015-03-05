# Manifest for post build cleanup

# Disable non-local yum repos
yumrepo { [ 'updates', 'base', 'extras', 'epel']:
  enabled  => '0',
  priority => '99',
  skip_if_unavailable => '1',
}
