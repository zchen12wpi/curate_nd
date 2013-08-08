# Set up the Common Pacakges needed for CurateND

class lib_curate {

	# Binary package requirements
	
	$packagelist = [
    "clamav",
    "clamav-db",
    "clamav-devel",
    "ImageMagick",
    "GConf2",
    "ORBit2",
    "libIDL",
    "libcroco",
    "libgcrypt-devel",
    "libgpg-error-devel",
    "libgsf",
    "librsvg2",
    "libtool-ltdl",
    "libwmf-lite",
    "libxml2-devel",
    "libxslt-devel",
    "sgml-common",
    "htop",
    "tmux" ]

	package { $packagelist:
        	ensure => installed
	}

  include mysql
}
