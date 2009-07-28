package App::ZofCMS::Plugin::GoogleCalculator;

use warnings;
use strict;

our $VERSION = '0.0102';
use WWW::Google::Calculator;
use base 'App::ZofCMS::Plugin::Base';

sub _key { 'plug_google_calculator' }
sub _defaults {
    from_query => 1,
    expr       => undef,
    q_name     => 'calc',
}
sub _do {
    my ( $self, $conf, $t, $q, $config ) = @_;

    $conf->{expr} = $conf->{expr}->( $t, $q, $config )
        if ref $conf->{expr} eq 'CODE';

    my $v = $conf->{from_query}
    ? $q->{ $conf->{q_name} }
    : $conf->{expr};

    return
        unless defined $v
            and length $v;

    my $calc = WWW::Google::Calculator->new;
    my $result = $calc->calc( $v );

    if ( defined $result ) {
        $t->{t}{plug_google_calculator} = $result;
    }
    else {
        $t->{t}{plug_google_calculator_error} = $calc->error;

        $t->{t}{plug_google_calculator_error} = 'invalid input'
            unless defined $t->{t}{plug_google_calculator_error};
    }
}

1;
__END__

=head1 NAME

App::ZofCMS::Plugin::GoogleCalculator - simple plugin to interface with Google calculator

=head1 SYNOPSIS

In ZofCMS Template or Main Config File:

    plugins => [
        qw/GoogleCalculator/
    ],
    plug_google_calculator => {},

In HTML::Template template:

    <form action="" method="POST">
    <div>
        <label>Enter an expression: <input type="text" name="calc"></label>
        <input type="submit" value="Calculate">
    </div>
    </form>

    <tmpl_if name='plug_google_calculator_error'>
        <p class="error">Got error: <tmpl_var escape='html' name='plug_google_calculator_error'></p>
    <tmpl_else>
        <p>Result: <tmpl_var escape='html' name='plug_google_calculator'></p>
    </tmpl_if>

=head1 DESCRIPTION

The module is a plugin for L<App::ZofCMS> that provides a simple interface to Google
calculator (L<http://www.google.com/help/calculator.html>).
This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

=head1 FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

=head2 C<plugins>

    plugins => [
        qw/GoogleCalculator/
    ],

B<Mandatory>. You need to include the plugin in the list of plugins to execute.

=head2 C<plug_google_calculator> 

    plug_google_calculator => {}, # run with all the defaults


    plug_google_calculator => {  ## below are the default values
        from_query => 1,
        q_name     => 'calc',
        expr       => undef,
    }

B<Mandatory>. Takes a hashref as a value. To run with all the defaults, pass an empty hashref.
Hashref's keys/values are as follows:

=head3 C<from_query>

    plug_google_calculator => {
        from_query  => 1,
    }

B<Optional>. Takes either true or false values. When set to a true value, the expression
to calculate will be taken from query parameters and parameter's name will be derived
from C<q_name> argument (see below). When set to a false value, the expression will
be taken from C<expr> argument (see below) directly. B<Defaults to:> C<1>

=head3 C<q_name>

    plug_google_calculator => {
        q_name     => 'calc',

B<Optional>. When C<from_query> argument is set to a true value, specifies the name
of the query parameter from which to gather the expression to calculate.
B<Defaults to:> C<calc>

=head3 C<expr>

    plug_google_calculator => {
        expr       => '2*2',
    }

    plug_google_calculator => {
        expr       => sub {
            my ( $t, $q, $config ) =  @_;
            return '2' . $q->{currency} ' in CAD';
        },
    }

B<Optional>. When C<from_query> argument is set to a false value, specifies the expression
to calculate. Takes either a literal expression as a string or a subref as a value.
When set to a subref, subref will be executed and its return value will be assigned
to C<expr> as if it was already there (note, C<undef>s will cause the plugin to
stop further processing). The sub's C<@_> will contain the following (in that order):
ZofCMS Template hashref, query parameters hashref and L<App::ZofCMS::Config> object.
B<Defaults to:> C<undef>

=head1 PLUGIN OUTPUT

    <tmpl_if name='plug_google_calculator_error'>
        <p class="error">Got error: <tmpl_var escape='html' name='plug_google_calculator_error'></p>
    <tmpl_else>
        <p>Result: <tmpl_var escape='html' name='plug_google_calculator'></p>
    </tmpl_if>

=head2 C<plug_google_calculator>

    <p>Result: <tmpl_var escape='html' name='plug_google_calculator'></p>

If result was calculated successfully, the plugin will set
C<< $t->{t}{plug_google_calculator} >> to the result string where C<$t> is ZofCMS Template
hashref.

=head2 C<plug_google_calculator_error>

    <tmpl_if name='plug_google_calculator_error'>
        <p class="error">Got error: <tmpl_var escape='html' name='plug_google_calculator_error'></p>
    </tmpl_if>

If an error occured during the calculation, C<< $t->{t}{plug_google_calculator_error} >>
will be set to the error message where C<$t> is ZofCMS Template hashref.

=head1 AUTHOR

'Zoffix, C<< <'zoffix at cpan.org'> >>
(L<http://haslayout.net/>, L<http://zoffix.com/>, L<http://zofdesign.com/>)

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-zofcms-plugin-googlecalculator at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-ZofCMS-Plugin-GoogleCalculator>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::ZofCMS::Plugin::GoogleCalculator

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-ZofCMS-Plugin-GoogleCalculator>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-ZofCMS-Plugin-GoogleCalculator>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-ZofCMS-Plugin-GoogleCalculator>

=item * Search CPAN

L<http://search.cpan.org/dist/App-ZofCMS-Plugin-GoogleCalculator/>

=back



=head1 COPYRIGHT & LICENSE

Copyright 2009 'Zoffix, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

