package App::Web::Referendum::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
    render_die => 1,
);

=head1 NAME

App::Web::Referendum::View::TT - TT View for App::Web::Referendum

=head1 DESCRIPTION

TT View for App::Web::Referendum.

=head1 SEE ALSO

L<App::Web::Referendum>

=head1 AUTHOR

Pavel Shaydo,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
