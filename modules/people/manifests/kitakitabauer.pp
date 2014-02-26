class people::kitakitabauer {
  include virtualbox
  include vagrant
  $home = "/Users/${::boxen_user}"

  # via homebrew
  package {
    [
      'tmux',
      'tig',
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
  }

  # dotfiles setting
  $dotfiles = "${home}/dotfiles"

  repository { $dotfiles:
    source => 'kitakitabauer/dotfiles',
    provider => 'git'
  }
  exec { "submodule-clone":
    cwd => $dotfiles,
    command => 'git submodule init && git submodule update',
    require => Repository[$dotfiles],
  }

}

github "osx",    "1.6.0"

include  osx::dock::autohide
include  osx::software_update

git::config::global {
  'user.name':
    value => 'kitakitabauer' ;
  'user.email':
    value => 'kitakita.d.kitakita@gmail.com'
}

# class peope::kitakitabauer {
#   ruby::version { '1.9.3-p448': }
#   ruby::version { 'jruby-1.7.4': }
# }

class { 'ruby::global':
  version => '1.9.3-p448'
}
