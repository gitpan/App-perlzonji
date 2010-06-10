use 5.008;
use strict;
use warnings;

package App::perlzonji::Plugin::SpecialPackages;
BEGIN {
  $App::perlzonji::Plugin::SpecialPackages::VERSION = '1.101610';
}

# ABSTRACT: Plugin to find documentation for special Perl packages
use App::perlzonji;
App::perlzonji->add_trigger(
    'matches.add' => sub {
        my ($class, $word, $matches) = @_;
        $word =~ /^UNIVERSAL::/ && push @$matches, 'perlobj';
        $word =~ /^CORE::/      && push @$matches, 'perlsub';
    }
);
1;


__END__
=pod

=head1 NAME

App::perlzonji::Plugin::SpecialPackages - Plugin to find documentation for special Perl packages

=head1 VERSION

version 1.101610

=head1 SYNOPSIS

    # perlzonji UNIVERSAL::isa
    # (runs `perldoc perlobj`)

=head1 DESCRIPTION

This plugin for L<App::perlzonji> knows where special Perl packages like
C<UNIVERSAL::> and C<CORE::> are documented.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see
L<http://search.cpan.org/dist/App-perlzonji/>.

The development version lives at
L<http://github.com/hanekomu/App-perlzonji/>.
Instead of sending patches, please fork this project using the standard git
and github infrastructure.

=head1 AUTHOR

  Marcel Gruenauer <marcel@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Marcel Gruenauer.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

