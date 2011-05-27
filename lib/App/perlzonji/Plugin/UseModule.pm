use 5.008;
use strict;
use warnings;

package App::perlzonji::Plugin::UseModule;
BEGIN {
  $App::perlzonji::Plugin::UseModule::VERSION = '1.111470';
}

# ABSTRACT: Plugin to try the search word as a module name
use App::perlzonji;
App::perlzonji->add_trigger(
    'matches.add' => sub {
        my ($class, $word, $matches) = @_;
        my $try_module = sub {
            my $module = shift;
            eval "use $module;";
            !$@ && push @$matches, $module;
        };

        # try it as a module
        $try_module->($word);

     # if it contains '::', it's not a function - strip off the last bit and try
     # that again as a module
        $word =~ s/::(\w+)$// && $try_module->($word);
    }
);
1;
1;


__END__
=pod

=head1 NAME

App::perlzonji::Plugin::UseModule - Plugin to try the search word as a module name

=head1 VERSION

version 1.111470

=head1 SYNOPSIS

    # perlzonji Devel::SearchINC

=head1 DESCRIPTION

This plugin for L<App::perlzonji> tries to use the search term as a module
name. If the module can be loaded, it is added to the match results. In case
the search term looks like a fully qualified function name such as
C<Foo::Bar::some_function>, the function part is stripped off the the
remainder is tried again.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org/Public/Dist/Display.html?Name=App-perlzonji>.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see L<http://search.cpan.org/dist/App-perlzonji/>.

The development version lives at L<http://github.com/hanekomu/App-perlzonji>
and may be cloned from L<git://github.com/hanekomu/App-perlzonji.git>.
Instead of sending patches, please fork this project using the standard
git and github infrastructure.

=head1 AUTHORS

=over 4

=item *

Marcel Gruenauer <marcel@cpan.org>

=item *

Leo Lapworth <LLAP@cuckoo.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Marcel Gruenauer.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

