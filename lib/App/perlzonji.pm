use 5.008;
use strict;
use warnings;

package App::perlzonji;
our $VERSION = '1.100770';

# ABSTRACT: a more knowledgeable perldoc
use Pod::Usage::CommandLine qw(GetOptions pod2usage);

# Specify like this because it's easier. We compute the reverse later (i.e.,
# it should be easier on the hacker than on the computer).
#
# Note: 'for' is a keyword for perlpod as well ('=for'), but is listed for
# perlsyn here, as that's more likely to be the intended meaning.
our %found_in = (
    perlop => [
        qw(lt gt le ge eq ne cmp not and or xor s m tr y
          q qq qr qx qw)
    ],
    perlsyn => [qw(if else elsif unless while until for foreach)],
    perlobj => [qw(isa ISA can VERSION)],
    perlsub => [qw(AUTOLOAD BEGIN CHECK INIT END DESTROY)],
    perltie => [
        qw(TIESCALAR TIEARRAY TIEHASH TIEHANDLE FETCH STORE UNTIE
          FETCHSIZE STORESIZE POP PUSH SHIFT UNSHIFT SPLICE DELETE EXISTS
          EXTEND CLEAR FIRSTKEY NEXTKEY WRITE PRINT PRINTF READ READLINE GETC
          CLOSE)
    ],
    perlvar => [
        qw(_ a b 0 1 2 3 4 5 6 7 8 9 ARG STDIN STDOUT STDERR ARGV
          ENV PREMATCH MATCH POSTMATCH LAST_PAREN_MATCH LAST_MATCH_END
          MULTILINE_MATCHING INPUT_LINE_NUMBER NR INPUT_RECORD_SEPARATOR RS
          OUTPUT_AUTOFLUSH OUTPUT_FIELD_SEPARATOR OFS OUTPUT_RECORD_SEPARATOR
          ORS LIST_SEPARATOR SUBSCRIPT_SEPARATOR SUBSEP OFMT FORMAT_PAGE_NUMBER
          FORMAT_LINES_PER_PAGE FORMAT_LINES_LEFT LAST_MATCH_START FORMAT_NAME
          FORMAT_TOP_NAME FORMAT_LINE_BREAK_CHARACTERS FORMAT_FORMFEED
          ACCUMULATOR CHILD_ERROR ENCODING OS_ERROR ERRNO EXTENDED_OS_ERROR
          EVAL_ERROR PROCESS_ID PID REAL_USER_ID UID EFFECTIVE_USER_ID EUID
          REAL_GROUP_ID GID EFFECTIVE_GROUP_ID EGID PROGRAM_NAME COMPILING
          DEBUGGING SYSTEM_FD_MAX INPLACE_EDIT OSNAME OPEN PERLDB
          LAST_REGEXP_CODE_RESULT EXCEPTIONS_BEING_CAUGHT BASETIME TAINT UNICODE
          PERL_VERSION WARNING WARNING_BITS EXECUTABLE_NAME ARGVOUT INC SIG
          __DIE__ __WARN__)
    ],
    perlrun => [
        qw(HOME LOGDIR PATH PERL5LIB PERL5OPT PERLIO PERLIO_DEBUG PERLLIB
          PERL5DB PERL5DB_THREADED PERL5SHELL PERL_ALLOW_NON_IFS_LSP
          PERL_DEBUG_MSTATS PERL_DESTRUCT_LEVEL PERL_DL_NONLAZY PERL_ENCODING
          PERL_HASH_SEED PERL_HASH_SEED_DEBUG PERL_ROOT PERL_SIGNALS
          PERL_UNICODE)
    ],
    perlpod => [
        qw(head1 head2 head3 head4 over item back cut pod begin
          end)
    ],
    perldata => [qw(__FILE__ __LINE__ __PACKAGE__)],

    # We could also list common functions and methods provided by some
    # commonly used modules, like:
    Moose => [
        qw(has before after around super override inner augment confessed
           extends with)
    ],
    Error      => [qw(try catch except otherwise finally record)],
    SelfLoader => [qw(__DATA__ __END__ DATA)],
    Storable     => [qw(freeze thaw)],
    Carp         => [qw(carp cluck croak confess shortmess longmess)],
    'Test::More' => [
        qw(plan use_ok require_ok ok is isnt like unlike cmp_ok
          is_deeply diag can_ok isa_ok pass fail eq_array eq_hash eq_set skip
          todo_skip builder SKIP: TODO:)
    ],
    'Getopt::Long' => [qw(GetOptions)],
    'File::Find'   => [qw(find finddepth)],
    'File::Path'   => [qw(mkpath rmtree)],
    'File::Spec'   => [
        qw(canonpath catdir catfile curdir devnull rootdir
          tmpdir updir no_upwards case_tolerant file_name_is_absolute path
          splitpath splitdir catpath abs2rel rel2abs)
    ],
    'File::Basename' => [
        qw(fileparse fileparse_set_fstype basename
          dirname)
    ],
    'File::Temp' => [
        qw(tempfile tempdir tmpnam tmpfile mkstemp mkstemps
          mkdtemp mktemp unlink0 safe_level)
    ],
    'File::Copy' => [qw(copy move cp mv rmscopy)],
    'PerlIO'     => [
        qw(:bytes :crlf :mmap :perlio :pop :raw :stdio :unix :utf8 :win32)
    ],
);

sub run {
    our %opt = ('perldoc-command' => 'perldoc');
    GetOptions(\%opt, 'perldoc-command:s', 'debug') or pod2usage(2);
    my $word = shift @ARGV;

    while (my ($file, $words) = each our %found_in) {
        $_ eq $word && execute($opt{'perldoc-command'} => $file) for @$words;
    }

    # Is it a label (ends with ':')? Do this after %found_in, because there are
    # special labels such as 'SKIP:' and 'TODO:' that map to Test::More
    $word =~ /^\w+:$/       && execute($opt{'perldoc-command'} => 'perlsyn');
    $word =~ /^UNIVERSAL::/ && execute($opt{'perldoc-command'} => 'perlobj');
    $word =~ /^CORE::/      && execute($opt{'perldoc-command'} => 'perlsub');

    # try it as a module
    try_module($word);

    # if it contains '::', it's not a function - strip off the last bit and try
    # that again as a module
    $word =~ s/::(\w+)$// && try_module($word);

    # otherwise, assume it's a function
    execute($opt{'perldoc-command'}, qw(-f), $word);
}

# if we can require() it, we run perldoc for the module
sub try_module {
    my $module = shift;
    our %opt;
    eval "use $module;";
    !$@ && execute($opt{'perldoc-command'} => $module);
}

sub execute {
    our %opt;
    print "@_\n" if $opt{debug};
    exec @_;
}
1;


__END__
=pod

=head1 NAME

App::perlzonji - a more knowledgeable perldoc

=head1 VERSION

version 1.100770

=for stopwords Dieckow gozonji desu ka

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

