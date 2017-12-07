package Chapix::Manager::API;

use lib('../');
use lib('../cpan/');
use warnings;
use strict;
use Carp;
use Digest::SHA qw(sha384_hex sha1_hex);

use Chapix::Conf;
use Chapix::Com;

# Language
#use Chapix::Manager::L10N;
#my $lh = Chapix::Manager::L10N->get_handle($sess{user_language}) || die "Language?";
#sub loc (@) { return ( $lh->maketext(@_)) }



1;
