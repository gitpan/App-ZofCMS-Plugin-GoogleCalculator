use Test::More tests => 3;

BEGIN {
    use_ok('WWW::Google::Calculator');
    use_ok('App::ZofCMS::Plugin::Base');
    use_ok( 'App::ZofCMS::Plugin::GoogleCalculator' );
}

diag( "Testing App::ZofCMS::Plugin::GoogleCalculator $App::ZofCMS::Plugin::GoogleCalculator::VERSION, Perl $], $^X" );
