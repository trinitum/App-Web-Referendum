package App::Web::Referendum::Schema::ResultSet::Question;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub voting_results {
    my $self  = shift;
    my $args  = shift || {};
    $self->result_class('DBIx::Class::ResultClass::HashRefInflator');
    $self->search(
        $args,
        {
            select => [
                \'id',
                \'question',
                { sum => 'votes.vote' },
                { sum => '1 - votes.vote' },
                "count(votes.question_id) - count(votes.vote)",
            ],
            as       => [qw(id question yep nope dunno)],
            join     => [qw(votes)],
            order_by => { -asc => [qw(referendum_id id)] },
            group_by => ['id'],
        }
    );
}

1;
