package App::perlzonji::Plugin::UseModule;
use 5.008;
use strict;
use warnings;
use App::perlzonji;
our $VERSION = '2.00';
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
__END__

=pod

=head1 NAME

App::perlzonji::Plugin::UseModule - Plugin to try the search word as a module name

=head1 SYNOPSIS

    # perlzonji Devel::SearchINC

=head1 DESCRIPTION

This plugin for L<App::perlzonji> tries to use the search term as a module
name. If the module can be loaded, it is added to the match results. In case
the search term looks like a fully qualified function name such as
C<Foo::Bar::some_function>, the function part is stripped off the the
remainder is tried again.

