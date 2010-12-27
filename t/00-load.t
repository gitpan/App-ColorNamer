#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 12630;

BEGIN {
    use_ok('Convert::Color');
    use_ok('Class::Data::Accessor');
    use_ok('App::ColorNamer');
}

diag( "Testing App::ColorNamer $App::ColorNamer::VERSION, Perl $], $^X" );


my $app = App::ColorNamer->new;

my @dumps = get_dump_vars();
is_deeply($app->get_name('#aaa'), $dumps[0], 'Color #aaa');
is_deeply($app->get_name('#bbbaaa'), $dumps[1], 'Color #bbbaaa');
is_deeply($app->get_name('fff'), $dumps[2], 'Color fff');
is_deeply($app->get_name('#bbbaaa', 1), $dumps[3], 'Color #bbbaaa with sane colors turned on');
is_deeply($app->color, $dumps[3], 'Return of ->color()');
is(scalar($app->get_name('#')), undef, 'Invalid color');
is($app->error, "Color code must be either three or six hex digits", '->error() return after invalid color');

my $known_colors = $app->known_colors;
is(ref $known_colors, 'ARRAY', 'Value type of ->known_colors');

for ( @$known_colors ) {
    my $ident =  " $_->{name} ($_->{hex})";
    
    is(ref $_->{rgb}, 'HASH', 'ref $_->{rgb}');
    is(
        join('', sort keys %{ $_->{rgb} }),
        'bgr',
        '$_->{rgb}' . $ident,
    );
    
    is(ref $_->{hsl}, 'HASH', 'ref $_->{hsl}');
    is(
        join('', sort keys %{ $_->{hsl} }),
        'hls',
        '$_->{hsl}' . $ident,
    );
    
    ok( exists $_->{name}, '$_->{name}' . $ident );
    ok( length $_->{name}, 'length $_->{name}' . $ident );
    ok( exists $_->{hex}, '$_->{hex}' . $ident );
    like( $_->{hex}, qr/^[[:xdigit:]]{6}$/, '$_->{hex} value ' . $ident );
}

my $sane_colors = $app->sane_colors;
is(ref $sane_colors, 'ARRAY', 'Value type of ->sane_colors');

for ( @$sane_colors ) {
    like( $_, qr/^[[:xdigit:]]{6}$/, "Sane color $_");
}

$app->sane_colors(['FFFFFF', 'ACA59F']);
is_deeply($app->sane_colors, ['FFFFFF', 'ACA59F'], '->sane_colors()');
is_deeply($app->get_name('#aaa', 1), $dumps[4], '->get_name() with user specified sane colors');

sub get_dump_vars {
    return (
        {
          "rgb" => {
                     "r" => 172,
                     "b" => 172,
                     "g" => 172
                   },
          "name" => "Silver Chalice",
          "hsl" => {
                     "l" => "0.674509803921569",
                     "h" => 0,
                     "s" => 0
                   },
          "hex" => "acacac"
        },
        {
          "rgb" => {
                     "r" => 198,
                     "b" => 181,
                     "g" => 195
                   },
          "name" => "Ash",
          "hsl" => {
                     "l" => "0.743137254901961",
                     "h" => "49.4117647058823",
                     "s" => "0.129770992366412"
                   },
          "hex" => "c6c3b5"
        },
        {
          "rgb" => {
                     "r" => 255,
                     "b" => 255,
                     "g" => 255
                   },
          "name" => "White",
          "exact" => 1,
          "hsl" => {
                     "l" => 1,
                     "h" => 0,
                     "s" => 0
                   },
          "hex" => "ffffff"
        },
        {
          "rgb" => {
                     "r" => 169,
                     "b" => 145,
                     "g" => 164
                   },
          "name" => "Gray Olive",
          "hsl" => {
                     "l" => "0.615686274509804",
                     "h" => "47.5",
                     "s" => "0.122448979591837"
                   },
          "hex" => "a9a491"
        },
        {
          "rgb" => {
                     "r" => 172,
                     "b" => 159,
                     "g" => 165
                   },
          "name" => "Cloudy",
          "hsl" => {
                     "l" => "0.649019607843137",
                     "h" => "27.6923076923077",
                     "s" => "0.0726256983240224"
                   },
          "hex" => "aca59f"
        }
    );
}
