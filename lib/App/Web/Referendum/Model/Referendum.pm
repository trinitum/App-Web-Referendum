package App::Web::Referendum::Model::Referendum;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'App::Web::Referendum::Schema',
    
    connect_info => {
        dsn => 'dbi:SQLite:ref.db',
        user => '',
        password => '',
    }
);

=head1 NAME

App::Web::Referendum::Model::Referendum - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<App::Web::Referendum>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<App::Web::Referendum::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.41

=head1 AUTHOR

Pavel Shaydo

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
