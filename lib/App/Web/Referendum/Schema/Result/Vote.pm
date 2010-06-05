package App::Web::Referendum::Schema::Result::Vote;

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 NAME

App::Web::Referendum::Schema::Result::Vote - votes table

=cut

__PACKAGE__->table("votes");

=head1 ACCESSORS

=head2 voter_id

ID of the voter

=head2 question_id

question ID

=head2 vote

vote

=cut

__PACKAGE__->add_columns(
    voter_id => {
        data_type   => "integer",
        is_nullable => 0
    },
    question_id => {
        data_type   => "integer",
        is_nullable => 0
    },
    vote => {
        data_type   => "integer",
        is_nullable => 1
    },
);

sub vote_as_string {
    my $self = shift;
    return "Don't know" unless defined $self->vote;
    $self->vote ? "Yes" : "No";
}

__PACKAGE__->set_primary_key( "voter_id", "question_id" );

__PACKAGE__->belongs_to( voter => 'App::Web::Referendum::Schema::Result::Voter', 'voter_id' );
__PACKAGE__->belongs_to(
    question => 'App::Web::Referendum::Schema::Result::Question',
    'question_id'
);

1;
