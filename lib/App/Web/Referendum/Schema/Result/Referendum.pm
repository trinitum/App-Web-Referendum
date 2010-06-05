package App::Web::Referendum::Schema::Result::Referendum;

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 NAME

App::Web::Referendum::Schema::Result::Referendum - referendum table

=cut

__PACKAGE__->table("referendums");

=head1 ACCESSORS

=head2 id

referendum ID

=head2 subject

Subject of the referendum

=cut

__PACKAGE__->add_columns(
  id =>  {
      data_type => "integer",
      is_auto_increment => 1, 
      is_nullable => 0
  },
  subject =>  {
      data_type => "text",
      is_nullable => 0 
  },
);

__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("referendums_unique", ["subject"]);

__PACKAGE__->has_many(questions => 'App::Web::Referendum::Schema::Result::Question', 'referendum_id');

1;
