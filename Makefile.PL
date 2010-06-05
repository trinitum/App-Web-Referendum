#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'App-Web-Referendum';
all_from 'lib/App/Web/Referendum.pm';

requires 'Catalyst::Runtime' => '5.80024';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::General';
requires 'HTML::FormHandler';
requires 'HTML::FormHandler::Model::DBIC';
requires 'Catalyst::Model::DBIC::Schema';
requires 'DBD::SQLite';
requires 'Template';
requires 'Catalyst::View::TT';

test_requires 'Test::More' => '0.88';
test_requires 'Test::Most';
test_requires 'Test::WWW::Mechanize::Catalyst';
test_requires 'HTML::TableExtract';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
