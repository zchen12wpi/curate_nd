# Set up the Common Pacakges needed for CurateND

class lib_curate {

	# Binary package requirements
	
	$packagelist = [ "clamav" , "clamav-db", "clamav-devel", "ImageMagick", "GConf2", "ORBit2", "libIDL", "libcroco", "libgsf", "librsvg2", "libtool-ltdl", "libwmf-lite", "sgml-common", "htop", "tmux" ]

	package { $packagelist:
        	ensure => installed
	}
}
