# == Class consul::params
#
# This class is meant to be called from consul
# It sets variables according to platform
#
class consul::params {

  $install_method        = 'url'
  $package_name          = 'consul'
  $package_ensure        = 'latest'
  $download_url_base     = 'https://dl.bintray.com/mitchellh/consul/'
  $download_extension    = 'zip'
  $ui_package_name       = 'consul_ui'
  $ui_package_ensure     = 'latest'
  $ui_download_url_base  = 'https://dl.bintray.com/mitchellh/consul/'
  $ui_download_extension = 'zip'
  $version               = '0.5.2'

  if $::kernel == 'windows' {
    # only 32bit builds are available for windows
    $arch = '386'
    $base_dir = 'C:\Program Files\Consul'
    $bin_dir = 'C:\Program Files\Consul\bin'
    $config_dir = 'C:\Program Files\Consul\etc'
  } else {
    $bin_dir = '/usr/local/bin'
    $config_dir = '/etc/consul'

    case $::architecture {
      'x86_64', 'amd64': { $arch = 'amd64' }
      'i386':            { $arch = '386'   }
      default:           {
        fail("Unsupported kernel architecture: ${::architecture}")
      }
    }
  }

  $os = downcase($::kernel)

  case $::operatingsystem {
    'Ubuntu' : {
      if versioncmp($::operatingsystemrelease, '8.04') < 1 {
        $init_style = 'debian'
      } elsif versioncmp($::operatingsystemrelease, '15.04') < 0 {
        $init_style = 'upstart'
      } else {
        $init_style = 'systemd'
      }
    }
    /Scientific|CentOS|RedHat|OracleLinux/: {
      if versioncmp($::operatingsystemrelease, '7.0') < 0 {
        $init_style = 'sysv'
      } else {
        $init_style  = 'systemd'
      }
    }
    'Fedora' : {
      if versioncmp($::operatingsystemrelease, '12') < 0 {
        $init_style = 'sysv'
      } else {
        $init_style = 'systemd'
      }
    }
    'Debian' : {
      if versioncmp($::operatingsystemrelease, '8.0') < 0 {
        $init_style = 'debian'
      } else {
        $init_style = 'systemd'
      }
    }
    'Archlinux' : {
      $init_style = 'systemd'
    }
    'SLES' : {
      $init_style = 'sles'
    }
    'Darwin' : {
      $init_style = 'launchd'
    }
    'Amazon' : {
      $init_style = 'sysv'
    }
    'windows' : {
      $init_style = 'windows'
    }
    default : {
      fail('Unsupported OS')
    }
  }
}
