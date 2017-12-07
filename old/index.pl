#!/usr/bin/perl


use lib qw(/home/17803/data/modules/share/perl/5.14.2);
use strict;
use CGI qw/:cgi/;
use CGI::Carp qw(fatalsToBrowser);

#print "Content-type: text/html\n\n";
#print "<html><head><title>test</title></head><body>";


use Chapix::Conf;
use Chapix::Com;
use Chapix::Controller;

Chapix::Controller::handler();
Chapix::Com::app_end();
exit;
