use strict;
use warnings;

package Dancer2::Plugin::UnicodeNormalize;
{
    $Dancer2::Plugin::UnicodeNormalize::VERSION = '0.02';
}

use Dancer2;
use Dancer2::Plugin;
use Unicode::Normalize;

on_plugin_import {
    my $dsl = shift;
    my $settings = plugin_setting();

    $dsl->app->add_hook(
        Dancer2::Core::Hook->new(
            name => 'before',
            code => sub {
                for (@{$settings->{'exclude'}}) { return if $dsl->request->path =~ /$_/ }

                my $form = $settings->{'form'} // 'NFC';
                my $normalizer = Unicode::Normalize->can($form);

                unless ($normalizer) {
                    require Carp;
                    Carp::croak( "Invalid normalization form '$form' requested" );
                }

                for (qw/query body route/) {
                    my $p = $dsl->request->params($_);
                    next unless $p;
                    %{$p} = map { $_ => $normalizer->($p->{$_}) } grep { $p->{$_} } keys $p;
                }
                $dsl->request->_build_params;
            },
        ),
    );
};

register_plugin for_versions => [2];

1;

__END__
=pod

=head1 NAME

Dancer2::Plugin::UnicodeNormalize - Normalize incoming Unicode parameters

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

    use Dancer2::Plugin::UnicodeNormalize

=head1 DESCRIPTION

Dancer2::Plugin::UnicodeNormalize normalizes all incoming parameters to a given
normalization form. This is achieved with a before hook, which should run
silently before processing each route. By default, we use Unicode Normalization
Form C - this is usually what you want. Other forms can be selected, see:
L</"CONFIGURATION">.

This plugin was inspired by L<Mojolicious::Plugin::UnicodeNormalize>. For
information on why Unicode Normalization is important, please see:

http://www.perl.com/pub/2012/05/perlunicookbook-unicode-normalization.html
http://www.modernperlbooks.com/mt/2013/11/mojolicious-unicode-normalization-plugin-released.html

=head1 CONFIGURATION

    plugins:
        UnicodeNormalize:
            form: NFC
            exclude:
                - '^/(css|javascripts|images)'

The C<form> parameter is described in L<Unicode::Normalize>. Default is NFC.

The C<exclude> parameter consists of a list of regular expressions to match
routes we do not wish to process parameters for.

=head1 AUTHOR

John Barrett, <john@jbrt.org>

=head1 CONTRIBUTING

http://github.com/jbarrett/Dancer2-Plugin-UnicodeNormalize

All comments and contributions welcome.

=head1 BUGS, SUPPORT

Please direct all requests to http://github.com/jbarrett/Dancer2-Plugin-UnicodeNormalize/issues
or email <john@jbrt.org>.

=head1 COPYRIGHT

Copyright 2013 John Barrett.

=head1 LICENSE

This application is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Dancer2>

L<Unicode::Normalize>

L<Mojolicious::Plugin::UnicodeNormalize>

=cut

