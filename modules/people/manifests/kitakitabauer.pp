class people::kitakitabauer {
  include chrome
  include macvim
  include wget
  
  include imagemagick
  include alfred
  
  # include redis
  
  include virtualbox
  include vagrant
  
  include  osx::dock::autohide
  include  osx::software_update
  
  git::config::global {
    'user.name':
      value => 'kitakitabauer' ;
    'user.email':
      value => 'kitakita.d.kitakita@gmail.com'
  }

  $home = "/Users/${::boxen_user}"

  # via homebrew
  package {
    [
      'tmux',
      'tig',
      'tree',
    ]:
  }

  # local application
  package {
    'GoogleJapaneseInput':
      source =>
        "http://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg",
      provider => pkgdmg;
    'XtraFinder':
      source => "http://www.trankynam.com/xtrafinder/downloads/XtraFinder.dmg",
      provider => pkgdmg;
    'zsh':
      install_options => [
        '--disable-etcdir',
      ];
    'RemoteDesktopConnectionClient':
      source => "http://download.microsoft.com/download/C/F/0/CF0AE39A-3307-4D39-9D50-58E699C91B2F/RDC_2.1.1_ALL.dmg",
      provider => pkgdmg;
    'BetterTouchTool':
      source => "http://www.boastr.de/BetterTouchTool.zip",
      provider => compressed_app;
    'ClipMenu':
      source => "https://dl.dropbox.com/u/1140644/clipmenu/ClipMenu_0.4.3.dmg",
      provider => pkgdmg;
  }

  # dotfiles setting
  $dotfiles = "${home}/dotfiles"

  repository { $dotfiles:
    source => 'kitakitabauer/dotfiles',
    provider => 'git'
  }
  exec { "cd ${dotfiles} && git checkout mac && sh ${dotfiles}/setup.sh":
    cwd => $dotfiles,
    require => Repository[$dotfiles],
  }
  exec { "submodule-clone":
    cwd => $dotfiles,
    command => 'git submodule init && git submodule update',
    require => Repository[$dotfiles],
  }
}

class zsh {
  require boxen::config

  file_line { 'add zsh to /etc/shells':
    path => '/etc/shells',
    line => "${boxen::config::homebrewdir}/bin/zsh",
    require => Package['zsh'],
    before => Osx_chsh[$::luser];
  }

  osx_chsh { $::luser:
    shell => "${boxen::config::homebrewdir}/bin/zsh";
  }
}

# NodeJS stuff
class { 'nodejs::global':
  version => 'v0.10'
}

# class peope::kitakitabauer {
#   ruby::version { '1.9.3-p448': }
#   ruby::version { 'jruby-1.7.4': }
# }

class { 'ruby::global':
  version => '1.9.3-p448'
}
