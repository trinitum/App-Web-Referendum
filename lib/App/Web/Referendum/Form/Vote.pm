package App::Web::Referendum::Form::Vote;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Table';

has '+item_class'    => ( default => 'Referendum' );
has referendum_id => ( is => 'rw' );

sub field_list {
    my $self = shift;
    my @fields = ( name => { type => 'Text', required => 1, noupdate => 1 } );
    my @questions = $self->schema->resultset('Question')->search({referendum_id => $self->referendum_id})->all;
    for my $question (@questions ) {
        push @fields, "question_" . $question->id, {
            type => 'Select',
            label => $question->question,
            options => [ { value => 1, label => 'Yes'}, { value => 0, label => 'No'}, { value => '', label => "Don't know"} ],
            widget => 'radio_group',
            noupdate => 1,
        }
    }
    push @fields, vote => { type => 'Submit' };
    return \@fields;
}

sub update_model {
    my $self = shift;
    my $voter_name = $self->field('name')->value;
    my $voter_id = $self->schema->resultset('Voter')->find_or_create({name => $voter_name})->id;
    my $rs_vote = $self->schema->resultset('Vote');
    my $rs_question = $self->schema->resultset('Question');
    for my $field ($self->fields) {
        next unless $field->name =~ /^question_([0-9]+)$/;
        my $question_id = $1;
        next unless $rs_question->find({ id => $question_id });
        $rs_vote->update_or_create(
            {
                voter_id    => $voter_id,
                question_id => $question_id,
                vote        => $field->value,
            },
            {
                key => 'primary',
            }
        );
    }
}

no HTML::FormHandler::Moose;
1;
