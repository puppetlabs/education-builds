class classroom::winserver {

  class { 'windows_ad' :
    install                    =>    $classroom::params::ad_install                
    installmanagementtools     =>    $classroom::params::ad_installmanagementtools 
    restart                    =>    $classroom::params::ad_restart                
    installflag                =>    $classroom::params::ad_installflag            
    configure                  =>    $classroom::params::ad_configure              
    configureflag              =>    $classroom::params::ad_configureflag          
    domaintype                 =>    $classroom::params::ad_domaintype             
    domain                     =>    $classroom::params::ad_domain                 
    domainname                 =>    $classroom::params::ad_domainname             
    netbiosdomainname          =>    $classroom::params::ad_netbiosdomainname      
    domainlevel                =>    $classroom::params::ad_domainlevel            
    forestlevel                =>    $classroom::params::ad_forestlevel            
    installtype                =>    $classroom::params::ad_installtype            
    installdns                 =>    $classroom::params::ad_installdns             
    dsrmpassword               =>    $classroom::params::ad_dsrmpassword           
  }

}
