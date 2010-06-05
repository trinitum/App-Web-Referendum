package App::Web::Referendum::Schema::Result::Voter;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

App::Web::Referendum::Schema::Result::Voter - voters table

=cut

__PACKAGE__->table("voters");

=head1 ACCESSORS

=head2 id

voter ID

=head2 name

voter name

=cut

__PACKAGE__->add_columns(
  id => {
      data_type => "integer",
      is_auto_increment => 1,
      is_nullable => 0 
  },
  name => {
      data_type => "text",
      is_nullable => 0
  },
);

__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("voters_unique", ["name"]);

__PACKAGE__->has_many(votes => 'App::Web::Referendum::Schema::Result::Vote', 'voter_id');

1;
