package App::Web::Referendum::Schema::Result::Question;

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 NAME

App::Web::Referendum::Schema::Result::Question questions table

=cut

__PACKAGE__->table("questions");

=head1 ACCESSORS

=head2 id

question ID

=head2 referendum_id

referendum ID

=head2 question

Question

=cut

__PACKAGE__->resultset_class('App::Web::Referendum::Schema::ResultSet::Question');

__PACKAGE__->add_columns(
  id =>  {
      data_type => "integer", 
      is_auto_increment => 1, 
      is_nullable => 0
  },
  referendum_id =>  {
      data_type => "integer",
      is_nullable => 0
  },
  question => { 
      data_type => "text",
      is_nullable => 0
  },
);
__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(referendum => 'App::Web::Referendum::Schema::Result::Referendum', 'referendum_id');
__PACKAGE__->has_many(votes => 'App::Web::Referendum::Schema::Result::Vote', 'question_id');

1;
