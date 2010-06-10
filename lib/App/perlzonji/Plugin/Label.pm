use 5.008;
use strict;
use warnings;

package App::perlzonji::Plugin::Label;
BEGIN {
  $App::perlzonji::Plugin::Label::VERSION = '1.101610';
}

# ABSTRACT: Plugin for labels
use App::perlzonji;
App::perlzonji->add_trigger(
    'matches.add' => sub {
        my ($class, $word, $matches) = @_;

     # Is it a label (ends with ':')? Do this after %found_in, because there are
     # special labels such as 'SKIP:' and 'TODO:' that map to Test::More
        if ($word =~ /^\w+:$/) { push @$matches, 'perlsyn' }
    }
);
1;


__END__
=pod

=head1 NAME

App::perlzonji::Plugin::Label - Plugin for labels

=head1 VERSION

version 1.101610

=head1 SYNOPSIS

    # perlzonji FOO:
    # (runs `perldoc perlsyn`)

=head1 DESCRIPTION

This plugin for L<App::perlzonji> checks whether the search term looks like a
label and if so, adds C<perlsyn> to the match results.

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

