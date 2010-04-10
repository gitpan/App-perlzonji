use 5.008;
use strict;
use warnings;

package App::perlzonji;
BEGIN {
  $App::perlzonji::VERSION = '1.101000';
}

# ABSTRACT: A more knowledgeable perldoc
use Pod::Usage::CommandLine qw(GetOptions pod2usage);
use Class::Trigger;
use Module::Pluggable require => 1;
__PACKAGE__->plugins;  # 'require' them

sub run {
    our %opt = ('perldoc-command' => 'perldoc');
    GetOptions(\%opt, 'perldoc-command:s', 'debug') or pod2usage(2);
    my $word = shift @ARGV;

    my @matches;
    __PACKAGE__->call_trigger('matches.add', $word, \@matches);
    if (@matches) {
        if (@matches > 1) {
            warn sprintf "%s matches for [%s], using first (%s):\n", scalar(@matches), $word, $matches[0];
            warn "    $_\n" for @matches;
        }
        execute($opt{'perldoc-command'}, $matches[0]);
    }

    # fallback
    warn "assuming that [$word] is a built-in function\n";
    execute($opt{'perldoc-command'}, qw(-f), $word);
}

sub execute {
    our %opt;
    print "@_\n" if $opt{debug};
    exec @_;
}

1;


__END__
=pod

=for stopwords Dieckow gozonji desu ka

=head1 NAME

App::perlzonji - A more knowledgeable perldoc

=head1 VERSION

version 1.101000

=head1 SYNOPSIS

    # perlzonji UNIVERSAL::isa
    # (runs `perldoc perlobj`)

=head1 DESCRIPTION

C<perlzonji> is like C<perldoc> except it knows about more things. Try these:

    perlzonji xor
    perlzonji foreach
    perlzonji isa
    perlzonji AUTOLOAD
    perlzonji TIEARRAY
    perlzonji INPUT_RECORD_SEPARATOR
    perlzonji '$^F'
    perlzonji PERL5OPT
    perlzonji :mmap
    perlzonji __WARN__
    perlzonji __PACKAGE__
    perlzonji head4

For efficiency, C<alias pod=perlzonji>.

The word C<zonji> means "knowledge of" in Japanese. Another example is the
question "gozonji desu ka", meaning "Do you know?" - "go" is a prefix added
for politeness.

=head1 FUNCTIONS

=head2 run

The main function, which is called by the C<perlzonji> program.

=head2 try_module

Takes as argument the name of a module, tries to load that module and executes
the formatter, giving that module as an argument. If loading the module fails,
this subroutine does nothing.

=head2 execute

Executes the given command using C<exec()>. In debug mode, it also prints the
command before executing it.

=head1 OPTIONS

Options can be shortened according to L<Getopt::Long/"Case and abbreviations">.

=over

=item C<--perldoc-command>

Specifies the POD formatter/pager to delegate to. Default is C<perldoc>.
C<annopod> from L<AnnoCPAN::Perldoc> is a better alternative.

=item C<--debug>

Prints the whole command before executing it.

=item C<--help>

Prints a brief help message and exits.

=item C<--man>

Prints the manual page and exits.

=back

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org/Public/Dist/Display.html?Name=App-perlzonji>.

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

