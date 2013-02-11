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

define localrepo::pkgsync ($pkglist = $name, $source="", $server = "mirrors.cat.pdx.edu", $syncer = "rsync", $syncops = "default", $repopath) {


  File {
    mode  => 644,
    owner => root,
    group => root,
  }
  Exec {
    user      => root,
    group     => root,
    path      => "/usr/bin:/bin",
    timeout   => "3600",
    logoutput => 'on_failure',
    require   => [ File["${repopath}/RPMS"], File["/tmp/${name}list"] ],
  }
  file { "/tmp/${name}list":
    content => "${pkglist}",
    notify  => Exec["get_${name}"],
  }
  file { [ "${repopath}", "${repopath}/RPMS" ]:
    ensure => directory,
  }

  if ! $source {
    fail("localrepo::pkgsync error: source is required for ${syncer} syncer")
  }
  if $syncer == "rsync" {
    if $syncops == "default" {
      $syncops_real = "-rltDvzPH --delete --delete-after"
    } else {
      $syncops_real = $syncops
    }
    exec { "get_${name}":
      command => "${syncer} ${syncops_real} --include-from=/tmp/${name}list  --exclude=* ${server}${source} ${repopath}/RPMS",
      onlyif  => "${syncer} ${syncops_real} -n --include-from=/tmp/${name}list  --exclude=* ${server}${source} ${repopath}/RPMS | grep 'rpm$'",
    }
  } elsif $syncer == "yumdownloader" {
    if $syncops == "default" {
      $syncops_real = "--destdir=${repopath}/RPMS --enablerepo=${source} --resolve"
    } else {
      $syncops_real = $syncops
    }
    exec { "get_${name}":
      command => "${syncer} ${syncops_real} `cat /tmp/${name}list`",
    }
  } else {
    fail("localrepo error: ${syncer} syncer is unknown")
  }

}
