use strict;
use warnings;
use Test::Most;

BEGIN { use_ok 'App::Web::Referendum::Model::Referendum' }

App::Web::Referendum::Model::Referendum->config( connect_info => { dsn => 'dbi:SQLite:ref.db', } );

my $schema = App::Web::Referendum::Model::Referendum->new->schema;
$schema->deploy( { add_drop_table => 1 } );

my $rs_voter = $schema->resultset('Voter');
my @voters   = qw(Alice Bob Carry George Vincent);
$rs_voter->populate( [ map { { name => $_ } } @voters ] );
eq_or_diff(
    [ sort map { $_->name } $rs_voter->all ],
    \@voters,
    "Voters added to database"
);

my $rs_referendum = $schema->resultset('Referendum');
$rs_referendum->create(
    {
        subject   => 'Oil spill',
        questions => [ { id => 1, question => 'Should we get rid of this spill?' }, ],
    }
);
$rs_referendum->create(
    {
        subject   => 'ORM',
        questions => [
            { id => 2, question => 'Are ORMs good?' },
            { id => 3, question => 'Do you like DBIx::Class?' },
            { id => 4, question => 'Do you like Rose::DB::Object?' },
            { id => 5, question => 'Nobody want to answer that question' },
        ],
    }
);
eq_or_diff(
    [ sort map { $_->subject } $rs_referendum->all ],
    [ sort 'Oil spill', 'ORM' ],
    "referendums added to database"
);

my $rs_question = $schema->resultset('Question');
is $rs_question->search->count, 5, "five questions added to database";

my %votes = (
    Alice   => [qw(Yep Yep Yep Nope)],
    Bob     => [ undef, qw(Yep Yep Dunno) ],
    Carry   => [qw(Yep Nope Nope Nope)],
    George  => [qw(Yep Dunno Dunno Dunno)],
    Vincent => [ qw(Yep), undef, undef, undef ],
);

my $rs_vote = $schema->resultset('Vote');
for my $voter ( keys %votes ) {
    for ( 0 .. 3 ) {
        next unless $votes{$voter}[$_];
        my $vote = { Yep => 1, Nope => 0, Dunno => undef }->{$votes{$voter}[$_]};
        $rs_vote->create(
            {
                voter => { name => $voter },
                question_id => $_ + 1,
                vote  => $vote,
            }
        );
    }
}

is $rs_vote->find({ voter_id => 1, question_id => 1})->vote_as_string, "Yes", "Got stringified result";

# votes for all referendums
eq_or_diff(
    [ map { [ $_->get_column('yep'), $_->get_column('nope'), $_->get_column('dunno') ] } $rs_question->voting_results ],
    [ [ 4, 0, 0 ], [ 2, 1, 1 ], [ 2, 1, 1 ], [ 0, 2, 2 ], [ undef, undef, 0 ] ],
    "Correct voting results for all referendums"
);

# votes for specified referendum
eq_or_diff(
    [ map { [ $_->get_column('yep'), $_->get_column('nope'), $_->get_column('dunno') ] } $rs_question->voting_results({ referendum_id => 2 }) ],
    [ [ 2, 1, 1 ], [ 2, 1, 1 ], [ 0, 2, 2 ], [ undef, undef, 0 ] ],
    "Correct voting results for second referendum"
);

# votes for specified question
eq_or_diff(
    { $rs_question->voting_results({ id => 1 })->next->get_columns },
    { id => 1, question => 'Should we get rid of this spill?', 'yep' => 4, 'nope' => 0, 'dunno' => 0 },
    "Correct voting results for first question"
);

done_testing();
