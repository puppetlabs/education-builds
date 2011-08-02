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

define localrepo::repobuild ($repopath, $repoer = "createrepo", $repoops = "-C -p") {

  exec { "${name}_build":
    command     => "${repoer} ${repoops} ${repopath}",
    user        => puppet,
    group       => puppet,
    path        => "/usr/bin:/bin",
    refreshonly => true,
  }

  file { "/etc/yum.repos.d/${name}.repo":
    content => "[${name}]\nname=Locally stored packages for ${name}\nbaseurl=file://${repopath}\nenabled=1\ngpgcheck=0",
    require => Exec["${name}_build"],
  }

}
