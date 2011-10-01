# Author: Cody Herriges
# Pulls a selection of packages from a full Centos 5 mirror and
# drops the packages into a requested location on the local machine
# if any packages are updated it then runs createrepo to generate
# a local yum repo.  The local repos are meant to allow PuppetMaster
# trainings to be ran in the event that internet connectivity is an
# issue.
#
# All package patterns in each local repo need to currently be with in the
# same resource.  This is due to the method of retrieving and cleaning
# up packages; each resource declaration is going to issues a `rsync
# --delete` with means that you will only get packages from the final
# resource that runs.  Suboptimal, yes and I think I am going to solve
# this with a ruby manifest at some point.
#
# Example:
#   pkgsync { "base_pkgs":
#     pkglist  => "httpd*\nperl-DBI*\nlibart_lgpl*\napr*\nruby-rdoc*\nntp*\n",
#     repopath => "/var/yum/mirror/centos/5/os/i386",
#     source   => "::centos/5/os/i386/CentOS/",
#     notify   => Repobuild["base"]
#   }
#
#   repobuild { "base":
#     repopath => "${base}/mirror/centos/5/os/i386",
#   }

class localrepo {

  $base = "/var/yum"

  $directories = [ "${base}",
                   "${base}/mirror",
                   "${base}/mirror/epel",
                   "${base}/mirror/epel/5",
                   "${base}/mirror/epel/5/local",
                   "${base}/mirror/centos",
                   "${base}/mirror/centos/5",
                   "${base}/mirror/centos/5/os",
                   "${base}/mirror/centos/5/updates",
                   "${base}/mirror/puppetlabs",
                   "${base}/mirror/puppetlabs/local",
                   "${base}/mirror/puppetlabs/local/base", ]

  File { mode => 644, owner => root, group => root }

  file { $directories:
    ensure => directory,
    recurse => true,
  }

  package { 'createrepo':
    ensure => present,
  }

  ## Build the "base" repo
  localrepo::pkgsync { "base_pkgs":
    pkglist  => template("localrepo/base_pkgs.erb"),
    repopath => "${base}/mirror/centos/5/os/i386",
    syncer   => "yumdownloader",
    source   => "dvd",
    notify   => Repobuild["base_local"],
  }

  localrepo::repobuild { "base_local":
    repopath => "${base}/mirror/centos/5/os/i386",
    require  => Package["createrepo"],
    notify   => Exec["makecache"],
  }

  ## Build the "updates" repo
  #localrepo::pkgsync { "updates_pkgs":
  #  pkglist  => template("localrepo/updates_pkgs.erb"),
  #  repopath => "${base}/mirror/centos/5/updates/i386",
  #  source   => "::centos/5/updates/i386/RPMS/",
  #  notify   => Repobuild["updates_local"]
  #}

  #localrepo::repobuild { "updates_local":
  #  repopath => "${base}/mirror/centos/5/updates/i386",
  #  require  => Package["createrepo"],
  #  notify   => Exec["makecache"],
  #}

  ## Build the "epel" repo
  localrepo::pkgsync { "epel_pkgs":
    pkglist  => template("localrepo/epel_pkgs.erb"),
    repopath => "${base}/mirror/epel/5/local/i386",
    syncer   => "yumdownloader",
    source   => "epel",
    notify   => Repobuild["epel_local"],
  }

  localrepo::repobuild { "epel_local":
    repopath => "${base}/mirror/epel/5/local/i386",
    require  => Package["createrepo"],
    notify   => Exec["makecache"],
  }

  ## Build the "puppetlabs" repo
  localrepo::pkgsync { "puppetlabs_pkgs":
    pkglist  => template("localrepo/puppetlabs_pkgs.erb"),
    repopath => "${base}/mirror/puppetlabs/local/base/i386",
    syncer   => "yumdownloader",
    source   => "puppetlabs",
    notify   => Repobuild["puppetlabs_local"],
  }

  localrepo::repobuild { "puppetlabs_local":
    repopath => "${base}/mirror/puppetlabs/local/base/i386",
    require  => Package["createrepo"],
    notify   => Exec["makecache"],
  }

  exec { "makecache":
    command     => "yum makecache",
    path        => "/usr/bin",
    refreshonly => true,
    user        => root,
    group       => root,
  }
}
