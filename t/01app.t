#!/usr/bin/env perl
use strict;
use warnings;
use Test::Most;

use Test::WWW::Mechanize::Catalyst;
use HTML::TableExtract;

use ok 'App::Web::Referendum::Model::Referendum';
use ok 'App::Web::Referendum';
App::Web::Referendum::Model::Referendum->config( connect_info => { dsn => 'dbi:SQLite:ref.db', } );
my $schema = App::Web::Referendum::Model::Referendum->new->schema;
$schema->deploy( { add_drop_table => 1 } );

my $mech = Test::WWW::Mechanize::Catalyst->new( catalyst_app => 'App::Web::Referendum' );

$mech->get_ok( '/', "Got root page" );

# create referendum
$mech->follow_link_ok( { text_regex => qr/add referendum/i }, "Got add referendum form" );
$mech->field( 'subject', "First subject" );
$mech->click_ok( 'create', "Create first referendum" );
$mech->follow_link_ok( { text_regex => qr/add question/i }, "Got add question page" );
$mech->field( 'question', "Should we?" );
$mech->click_ok( 'create', "Create first question" );
$mech->follow_link_ok( { text_regex => qr/add question/i }, "Got add question page" );
$mech->field( 'question', "Is it really 42?" );
$mech->click_ok( 'create', "Create second question" );
$mech->follow_link_ok( { text_regex => qr/add question/i }, "Got add question page" );
$mech->field( 'question', "Should I add more questions?" );
$mech->click_ok( 'create', "Create third question" );
$mech->content_contains( 'Should we?', "First question in the list" );
$mech->content_contains( '42',         "Second here too" );
$mech->get_ok( "/", "List of referendums" );

# vote on referendum
$mech->follow_link_ok( { text_regex => qr/first subject/i }, "Got list of votes" );
$mech->follow_link_ok( { text_regex => qr/vote/i }, "Got voting page" );
$mech->field( 'name', "Alice" );
$mech->field( 'question_1', '1' );
$mech->field( 'question_2', '0' );
$mech->field( 'question_3', '' );
$mech->click_ok( 'vote', "Alice's vote submitted" );
$mech->follow_link_ok( { text_regex => qr/vote/i }, "Got voting page" );
$mech->field( 'name', "Bob" );
$mech->field( 'question_1', '1' );
$mech->field( 'question_2', '1' );
$mech->field( 'question_3', '0' );
$mech->click_ok( 'vote', "Bob's vote submitted" );

# check voting results
my $te = HTML::TableExtract->new( headers => [ 'Yes', 'No', "Don't know" ] );
$te->parse($mech->content);
my $results = [ $te->rows ];
eq_or_diff(
    $results,
    [ [ 2, undef, undef], [1, 1, undef], [undef, 1, 1] ],
    "Voting results are correct"
);

# list of voters
$mech->get_ok( "/", "List of referendums" );
$mech->follow_link_ok( { text_regex => qr/voters/i }, "Got list of voters" );
$mech->follow_link_ok( { text_regex => qr/Alice/ }, "Got list of Alice's votes");
$te = HTML::TableExtract->new( headers => [ 'Vote' ] );
$te->parse($mech->content);
eq_or_diff( [ $te->rows ], [ 'Yes', 'No', "Don't know" ], "Correct votes for Alice");

# votes for question
$mech->get_ok( "/", "List of referendums" );
$mech->follow_link_ok( { text_regex => qr/first subject/i }, "Got list of votes" );
$mech->follow_link_ok( { text_regex => qr/42/i }, "Got list of votes for second question" );
$te = HTML::TableExtract->new( headers => [ 'Voter', 'Vote' ] );
$te->parse($mech->content);
eq_or_diff( [ $te->rows ], [ [ qw(Alice No) ], [ qw(Bob Yes) ] ], "Correct votes for question");

done_testing();
