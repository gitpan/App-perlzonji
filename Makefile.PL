
use strict;
use warnings;

BEGIN { require 5.008; }

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'A more knowledgeable perldoc',
  'AUTHOR' => 'Marcel Gruenauer <marcel@cpan.org>, Leo Lapworth <LLAP@cuckoo.org>',
  'BUILD_REQUIRES' => {
    'Capture::Tiny' => '0',
    'Carp' => '0',
    'English' => '0',
    'File::Find' => '0',
    'File::Temp' => '0',
    'Scalar::Util' => '0',
    'Test::More' => '0.94'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.30'
  },
  'DISTNAME' => 'App-perlzonji',
  'EXE_FILES' => [
    'bin/perlzonji'
  ],
  'LICENSE' => 'perl',
  'NAME' => 'App::perlzonji',
  'PREREQ_PM' => {
    'Class::Trigger' => '0',
    'Getopt::Long' => '0',
    'Module::Pluggable' => '0',
    'Pod::Usage' => '0'
  },
  'VERSION' => '1.111470',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



