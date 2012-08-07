class fundamentals::nfs::client {
 mount { "/root/master_home":
        device  => "${::serverip}:/home/${::hostname}",
        fstype  => "nfs",
        ensure  => "mounted",
        options => "rw",
        atboot  => true,
 }
}
