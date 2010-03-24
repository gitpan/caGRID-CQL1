#-*-Perl-*-
# $Id: transfer.t 122 2010-03-22 20:41:17Z osborneb $

use lib "./lib";
use strict;

BEGIN: {
	eval { require Test::More; };
	if ( $@ ) {
		use lib 't/lib';
	}
	use Test::More tests => 12;

	use_ok('caGRID::Transfer::Client');
	use_ok('caGRID::Net::Util');

}

use LWP::UserAgent;
use HTTP::Request;
use XML::LibXML::Reader;

my $host = 'http://tutorials2.training.cagrid.org:8080';

my $stockManager = "$host/wsrf/services/cagrid/StockManager";
my $portfolioManager = "$host/wsrf/services/cagrid/StockPortfolioManager";

my $wsaNS = "http://schemas.xmlsoap.org/ws/2004/03/addressing";
my $transferNS = "http://transfer.cagrid.org/TransferService/Context";
my $portfolioNS = "http://stockmanager.tutorial.introduce.cagrid.org/StockManager/Portfolio";

my ($reader, @keys, $resp);

my $t = caGRID::Transfer::Client->new();

SKIP:{

	@keys = getExpriKey();

	eval {
		$resp = $t->downloadData(@keys);
	} ;
	if ($@)
	  {
		  fail("downloadData fails:$@");
	  } else
		 {
			 pass("downloadData passes");
		 }
    
    eval {
	$resp = $t->downloadDataToCB(@keys, sub {});
    } ;
    if ($@)
    {
	fail("downloadDataToCB fails:$@");
    } else
    {
	pass("downloadDataToCB passes");
    }
    
    eval {
	$t->downloadDataToFile(@keys, "temp.txt");
    } ;
    if ($@)
    {
	fail("downloadToFile fails:$@");
    } else
    {
	pass("downloadToFile passes");
    }
    unlink("temp.txt");
    $t->destroy(@keys);
    
    eval {
	$resp = $t->downloadDataToCB(@keys, sub { });
    };
    if ($@)
    {
	pass("Error detection passes for downloadDataToCB");
    } else
    {
	fail("Error detection fails for downloadDataToCB");
    }
    
    eval {
	$resp = $t->downloadDataToFile(@keys, "temp.txt");
    };
    if ($@)
    {
	pass("Error detection passes for  downloadDataToFile");
    } else
    {
	fail("Error detection fails for downloadDataToFile");
    }
    unlink("temp.txt");
    eval {
	$resp = $t->downloadData(@keys);
    };
    if ($@)
    {
	pass("Error detection passes for downloadData");
    } else
    {
	fail("Error detection fails for downloadData");
    }
    

    my $portfolioKey = createPortfolio3();
    @keys = getExpriUploadKey($portfolioKey);
    eval{
	$resp = $t->uploadData(@keys, getExampleData());
    };
    if ($@)
    {
	fail("uploadData fails:$@");
    } else
    {
	pass("uploadData passes");
    }

    eval{
	$t->setStatus(@keys, $caGRID::Transfer::Client::_STAGED);
    };
    if ($@)
    {
	fail("setStatus fails:$@");
    }else
    {
	pass("setStatus pass");
    }

    eval{
	$t->destroy(@keys);
    };
    if ($@)
    {
	fail("destroy fails:$@");
    } else
    {
	pass("destroy passes");
    }
    

    @keys = getExpriUploadKey($portfolioKey);
    eval{

	open(OUT, ">temp.txt") or die "can not open temp.txt for writing";
	print OUT getExampleData();
	close(OUT);
	$resp = $t->uploadFile(@keys, "temp.txt");
    };
    unlink("temp.txt");
    if ($@)
    {
	fail("uploadFile fails:$@");
    } else
    {
	pass("uploadFile passes");
    }
    $t->setStatus(@keys, $caGRID::Transfer::Client::_STAGED);
    $t->destroy(@keys);

}

sub getExpriKey
{
    my $xml = q(
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/03/addressing">
<soapenv:Header>
</soapenv:Header>
<soapenv:Body>
		<GetChartRequest
			xmlns="http://stockmanager.tutorial.introduce.cagrid.org/StockManager">
			<symbol>
				<ns1:Symbol xmlns:ns1="http://tools.tutorial.introduce.cagrid.org/StockTools">GME</ns1:Symbol>
			</symbol>
		</GetChartRequest>
	</soapenv:Body>
</soapenv:Envelope>
);

    my $SOAPaction = "$stockManager/GetChartRequest";
    my $userAgent  = LWP::UserAgent->new( agent => 'transfer perl client' );
    my $request    = HTTP::Request->new( POST => $stockManager);
    $request->content_type("text/xml; charset=utf-8");
    $request->header( SOAPAction => $SOAPaction );
    $request->content($xml);
    my $response = $userAgent->request($request);
    
    unless ( $response->code == 200 ) {
	die $response->message();
    }

    my $content = $response->content();
    $reader = new XML::LibXML::Reader(string =>$content);
    return extractKey($reader);
}



sub createPortfolio3
{
    my $xml = q(<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/03/addressing">
<soapenv:Header></soapenv:Header><soapenv:Body>
<CreatePortfolioRequest xmlns="http://stockmanager.tutorial.introduce.cagrid.org/StockManager"><portfolioName>Portfolio 3</portfolioName></CreatePortfolioRequest></soapenv:Body></soapenv:Envelope>);
    my $SOAPaction = "http://stockmanager.tutorial.introduce.cagrid.org/StockManager/CreatePortfolioRequest";    
    my $userAgent  = LWP::UserAgent->new( agent => 'transfer perl client' );
    my $request    = HTTP::Request->new( POST => $stockManager);
    $request->content_type("text/xml; charset=utf-8");
    $request->header( SOAPAction => $SOAPaction );
    $request->content($xml);
    my $response = $userAgent->request($request);
    
    unless ( $response->code == 200 ) {
	die $response->message();
    }

    my $content = $response->content();
    my $reader = XML::LibXML::Reader->new(string => $content);

    while ( $reader->read ) {
	if (
	    $reader->localName() eq "StockPortfolioManagerResultsKey"
	    && $reader->namespaceURI() eq $portfolioNS
	    && $reader->nodeType() ==
	    XML_READER_TYPE_ELEMENT
	    )
	{
	    return $reader->readOuterXml();
	}
	
    }

    #portfolio created so far.
}

sub getExpriUploadKey
{

    my $portfolioKey = shift;
    my $xml = qq(<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/03/addressing">
<soapenv:Header>
$portfolioKey
</soapenv:Header><soapenv:Body>
<AddPortfolioSymbolsRequest xmlns="http://stockmanager.tutorial.introduce.cagrid.org/StockManager/Portfolio"/></soapenv:Body></soapenv:Envelope>);

    my $SOAPaction = "http://stockmanager.tutorial.introduce.cagrid.org/StockManager/Portfolio/AddPortfolioSymbolsRequest";
    my $userAgent  = LWP::UserAgent->new( agent => 'transfer perl client' );
    my $request    = HTTP::Request->new( POST => $portfolioManager);
    $request->content_type("text/xml; charset=utf-8");
    $request->header( SOAPAction => $SOAPaction );
    $request->content($xml);
    my $response = $userAgent->request($request);
    
    unless ( $response->code == 200 ) {
	die $response->message();
    }
    my $content=$response->content();
    $reader = XML::LibXML::Reader->new(string=>$content);
    return extractKey($reader);
}


sub extractKey
{
    my $reader = shift;
    my $inAddr = 0;
    my $epr = 0;
    my $dataKey = -1;

    while ( $reader->read ) {
	if (
	    $reader->localName() eq "EndpointReference"
	    && $reader->namespaceURI() eq $wsaNS
	    && $reader->nodeType() ==
	    XML_READER_TYPE_ELEMENT
	    )
	{
	    $inAddr=1;
	}
	
	if (
	    $reader->localName() eq "Address"
	    && $reader->namespaceURI() eq $wsaNS
	    && $reader->nodeType() ==
	    XML_READER_TYPE_ELEMENT && $inAddr
	      )
	{
	    $epr = 1;
	}
	if ($reader->nodeType() ==
	    XML_READER_TYPE_TEXT && $epr =~ /^1$/ )
	{
	    $epr = $reader->value();
	}

	if (
	    $reader->localName() eq "TransferServiceContextResultsKey"
	    && $reader->namespaceURI() eq $transferNS
	    && $reader->nodeType() ==
	    XML_READER_TYPE_ELEMENT && $inAddr
	    )
	{
	    $dataKey=1;
	}
	if ($reader->nodeType() ==
	    XML_READER_TYPE_TEXT && $dataKey =~ /^1$/ )
	{
	    $dataKey=$reader->value();
	}
    }
    $reader->close();
    $epr =~ s/\s+//g;
    $dataKey =~ s/\s+//g;
    return ($epr, $dataKey);
}


my $count = 0;
sub generateContent
{
    if ($count < 10)
    {
	$count++;
	my $line = "line $count\n";
	print $line;
	return $line;
    }
    return "";
}


sub getExampleData
{
	return q(
<Symbols>
 <ns1:Symbol xmlns:ns1="http://tools.tutorial.introduce.cagrid.org/StockTools">APPL</ns1:Symbol>
 <ns2:Symbol xmlns:ns2="http://tools.tutorial.introduce.cagrid.org/StockTools">BLDP</ns2:Symbol>
 <ns3:Symbol xmlns:ns3="http://tools.tutorial.introduce.cagrid.org/StockTools">MCD</ns3:Symbol>
 <ns4:Symbol xmlns:ns4="http://tools.tutorial.introduce.cagrid.org/StockTools">JPM</ns4:Symbol>
</Symbols>
);

}

