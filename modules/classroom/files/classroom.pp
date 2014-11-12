# Cut down on agent output noise.
Package { allow_virtual => true }

# dirty hack to allow student masters to download the agent tarball in Architect
Pe_staging::File { curl_option => '-k' }
