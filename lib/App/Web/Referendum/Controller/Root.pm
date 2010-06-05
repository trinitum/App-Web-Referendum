package App::Web::Referendum::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

use App::Web::Referendum::Form::Referendum;
has ref_form => (
    isa => 'App::Web::Referendum::Form::Referendum',
    is => 'rw',
    lazy => 1,
    default => sub { App::Web::Referendum::Form::Referendum->new },
);

use App::Web::Referendum::Form::Question;
has quest_form => (
    isa => 'App::Web::Referendum::Form::Question',
    is => 'rw',
    lazy => 1,
    default => sub { App::Web::Referendum::Form::Question->new },
);

use App::Web::Referendum::Form::Vote;
has vote_form => (
    isa => 'App::Web::Referendum::Form::Vote',
    is => 'rw',
    lazy => 1,
    default => sub { App::Web::Referendum::Form::Vote->new },
);

__PACKAGE__->config(namespace => '');

=head1 NAME

App::Web::Referendum::Controller::Root - Root Controller for App::Web::Referendum

=head1 DESCRIPTION

Implements functions for referendum

=head1 METHODS

=head2 index

The root page (/). Displays list of available referendums.

=cut
sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(referendums => $c->model('Referendum::Referendum'));
}

=head2 add

Add new referendum

=cut
sub add : Path('add') Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( form => $self->ref_form, object_type => 'Referendum'  );
    my $referendum = $c->model('Referendum::Referendum')->new_result( {} );
    return
      unless $self->ref_form->process(
        item   => $referendum,
        params => $c->req->parameters,
        schema => $c->model('Referendum')->schema
      );
    $c->res->redirect( $c->uri_for( '/view', $referendum->id ) );
}

=head2 view

View referendum results

=cut
sub view : Path('view') Args(1) {
    my ( $self, $c, $referendum_id ) = @_;
    my @results = map {
        { map { undef unless $_ } $_->get_columns }
    } $c->model('Referendum::Question')->voting_results( { referendum_id => $referendum_id } );
    $c->stash(
        voting_results => \@results,
        referendum     => $c->model('Referendum::Referendum')->find( { id => $referendum_id } )
    );
}

=head2 add_question

Add question to referendum

=cut
sub add_question : Path('add_question') Args(1) {
    my ( $self, $c, $referendum_id ) = @_;
    $c->stash( form => $self->quest_form, object_type => 'Question', template => 'add.tt2' );
    my $question = $c->model('Referendum::Question')->new_result( { referendum_id => $referendum_id } );
    return
      unless $self->quest_form->process(
        item   => $question,
        params => $c->req->parameters,
        schema => $c->model('Referendum')->schema
      );
    $c->res->redirect( $c->uri_for( '/view', $referendum_id ) );
}

=head2 vote

Voting form

=cut
sub vote : Path('vote') Args(1) {
    my ( $self, $c, $referendum_id ) = @_;
    $self->vote_form(
        App::Web::Referendum::Form::Vote->new(
            schema        => $c->model('Referendum')->schema,
            referendum_id => $referendum_id,
        )
    );
    $c->stash( form => $self->vote_form, object_type => 'Vote', template => 'add.tt2' );
    return
      unless $self->vote_form->process(
        params => $c->req->parameters,
        schema => $c->model('Referendum')->schema,
      );
    $c->res->redirect( $c->uri_for( '/view', $referendum_id ) );
}

sub question : Path('question') Args(1) {
    my ($self, $c, $question_id) = @_;
    $c->stash(
        votes => [ $c->model('Referendum::Vote')->search({question_id => $question_id}) ],
        question => $c->model('Referendum::Question')->find({id => $question_id}),
    );
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Pavel Shaydo,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
