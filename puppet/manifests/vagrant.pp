# Dev Machine on Vagrant,
# using Curate-ND staging provisoning 

include lib_hiera

$fedora_db_name = hiera( "fedora_db_name")
$mysql_root_password = hiera( "mysql_root_password")

# Add missing CentOS Classes

$packagelist = [ 'git', 'unzip', 'epel-release']

package { $packagelist:
	ensure => 'installed',
        before => Group["app"],
}

# Need app user, group

group { 'app':
	ensure => present,
	gid => 1518,
	before => User['app'],
} 

user { 'app':
	ensure => present,
	uid => 1518,
	gid => 1518,
	before => Class['lib_curate'],
}

class { 'mysql::server':
	root_password =>  $mysql_root_password,
       	require => [Package[$packagelist]],
} 

mysql::db { "${fedora_db_name}":
       	user => $fedora_admin_mysql,
       	password => $fedora_passwd_mysql,
       	host => 'localhost',
       	grant => ['all'],
       	require => Class['mysql::server'],
 }

 mysql::db { 'curate_staging':
            	user => 'rails',
            	password => 'rails',
            	host => 'localhost',
            	grant => ['all'],
            	require => Class['mysql::server'],
		before => Class['lib_curate'],
 }
     


# OK - build the application!

class { 'lib_curate':
      require => Package[$packagelist],
}



