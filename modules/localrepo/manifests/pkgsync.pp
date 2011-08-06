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

define localrepo::pkgsync ($pkglist = $name, $source, $server = "mirrors.cat.pdx.edu", $syncer = "rsync", $syncops = "-rltDvzPH --delete --delete-after", $repopath) {

  file { "/tmp/${name}list":
    content => "${pkglist}",
    mode     => 644,
    owner    => root,
    group    => root,
    notify   => Exec["get_${name}"],
  }

  file { [ "${repopath}", "${repopath}/RPMS" ]:
    ensure => directory,
    mode   => 644,
    owner  => root,
    group  => root,
  }

  exec { "get_${name}":
    command => "${syncer} ${syncops} --include-from=/tmp/${name}list  --exclude=* ${server}${source} ${repopath}/RPMS",
    user    => root,
    group   => root,
    path    => "/usr/bin:/bin",
    timeout => "2400",
    onlyif  => "${syncer} ${syncops} -n --include-from=/tmp/${name}list  --exclude=* ${server}${source} ${repopath}/RPMS | grep 'rpm$'",
    require  => [ File["${repopath}/RPMS"], File["/tmp/${name}list"] ],
  }
}
