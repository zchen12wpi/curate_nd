class lib_curate::disadis( $disadis_root = '/opt/disadis' ) {

	$pkglist = [ "mercurial", "golang" ]
	$disadis_fedora_url = hiera('disadis_fedora_url')

	package { $pkglist:
		ensure => present,
	}

	file { [ "$disadis_root", "${disadis_root}/log" ]:
		ensure => directory,
		require => Package[$pkglist],
	}

	exec { "Build-disadis-from-repo":
		environment => "GOPATH=${disadis_root}",
		path => "/usr/bin",
		command => "go get github.com/ndlib/disadis",
		# The following test seems like it will never update the binary if it has already been deployed.
		# Is there a test which would recompile the binary when the code changes?
		creates => "${disadis_root}/bin/disadis",
		require => File[$disadis_root],
	}

	file { 'disadis.conf':
		name => "${disadis_root}/settings.ini",
		replace => true,
		content => template('lib_curate/disadis-conf.erb'),
		require => Exec["Build-disadis-from-repo"],
	}

	file { 'upstart-disadis':
		name => '/etc/init/disadis.conf',
		replace => true,
		content => template('lib_curate/disadis-upstart.erb'),
		require => File["disadis.conf"],
	}

	file { 'logrotate.d/disadis':
		name => '/etc/logrotate.d/disadis',
		replace => true,
		require => File["upstart-disadis"],
		content => template('lib_curate/disadis-logrotate.erb'),
	}

	exec { "stop-disadis":
		command => "/sbin/initctl stop disadis",
		unless => "/sbin/initctl status disadis | grep stop",
		require => File['logrotate.d/disadis'],
	}

	exec { "start-disadis":
		command => "/sbin/initctl start disadis",
		unless => "/sbin/initctl status disadis | grep process",
		require => Exec["stop-disadis"]
	}

}
