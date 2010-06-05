package App::Web::Referendum::Controller::Voters;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

App::Web::Referendum::Controller::Voters - voters operations

=head1 DESCRIPTION

Display list of voters, votes for every voters

=head1 METHODS

=cut


=head2 index

Display list of voters

=cut
sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash(voters => $c->model('Referendum::Voter'));
}

sub view :Path('view') Args(1) {
    my ($self, $c, $voter_id) = @_;
    $c->stash(
        votes => [ $c->model('Referendum::Vote')->search({voter_id => $voter_id})->all ],
        voter => $c->model('Referendum::Voter')->find({id => $voter_id})
    );
}

=head1 AUTHOR

Pavel Shaydo,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
