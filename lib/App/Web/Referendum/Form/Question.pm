package App::Web::Referendum::Form::Question;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Table';

has '+item_class'    => ( default => 'Referendum' );
has_field 'question' => ( type => 'Text' );
has_field 'create'  => ( type => 'Submit');

no HTML::FormHandler::Moose;
1;

