#!/usr/bin/env perl

#written 18/1/2000 by chris@katipo.co.nz
# adapted for use in the hlt opac by finlay@katipo.co.nz 29/11/2002
#script to renew items from the web

use strict;
use warnings;

use CGI;
use C4::Circulation;
use C4::Auth;
use C4::Members;

my $query = new CGI;

my ( $template, $borrowernumber, $cookie ) = get_template_and_user(
	{
		  template_name   => "opac-user.tmpl",
		  query           => $query,
		  type            => "opac",
		  authnotrequired => 0,
		  flagsrequired   => { borrow => 1 },
		  debug           => 1,
	}
); 
my @items       = $query->param('item');
my $opacrenew   = C4::Context->preference("OpacRenewalAllowed");
my $borrower    = GetMember($borrowernumber);
for my $itemnumber ( @items ) {
    my ($status,$error) = CanBookBeRenewed( $borrowernumber, $itemnumber );
    if ( $status == 1 && $opacrenew == 1 ) {
        AddRenewal(borrowernumber=>$borrowernumber,itemnumber=>$itemnumber,borrower=>$borrower);
    }
}
# FIXME: else return ERROR to user!!

if ( $query->param('from') eq 'opac_user' ) {
    print $query->redirect("/cgi-bin/koha/opac-user.pl");
} 
# FIXME: ELSE WHAT?  No response at all.  Not very robust.
