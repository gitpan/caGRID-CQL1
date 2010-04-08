# $Id: Client.pm 147 2010-03-27 19:32:59Z osborneb $
package caGRID::Transfer::Client;

=head1 NAME

caGRID::Transfer::Client - Get access to the caGRID Transfer service.

=head1 USAGE

This XML fragment is an example TransferServiceContextReference response from a server. 
It is usually returned from some service method which uses the Transfer service.

	<ns1:TransferServiceContextReference
				xmlns:ns1="http://transfer.cagrid.org/TransferService/Context/types">
				<wsa:EndpointReference>
					<wsa:Address>http://127.0.0.1:9090/wsrf/services/cagrid/TransferServiceContext
					</wsa:Address>
					<wsa:ReferenceProperties>
						<ns2:TransferServiceContextResultsKey
							xmlns:ns2="http://transfer.cagrid.org/TransferService/Context">3e1cc2e0-deb6-11de-bc60-9ed210f988e4
						</ns2:TransferServiceContextResultsKey>
					</wsa:ReferenceProperties>
					<wsa:ReferenceParameters />
				</wsa:EndpointReference>
			</ns1:TransferServiceContextReference>

All public methods in this package accepts the value of Address element and the value of 
TransferServiceContextResultsKey element as first two arguments.

All methods die on server error or SOAP fault.

=head1 AUTHOR

Jason Zhang, Brian Osborne

Email jason@bioteam.net, briano@bioteam.net

=head1 COPYRIGHT and LICENSE

caBIG(r) Open Source Software License caGrid 1.3

Copyright 2010  The Ohio State University Research Foundation ("OSURF"),
Argonne National Laboratory ("ANL"), SemanticBits LLC ("SemanticBits"), and Ekagra
Software Technologies Ltd. ("Ekagra") ("caBIG(r) Participant").  The caGrid 1.3
software was created with NCI funding and is part of the caBIG(r) initiative.
The software subject to this notice and license includes both human readable
source code form and machine readable, binary, object code form (the "caBIG(r)
Software").

This caBIG(r) Software License (the "License") is between caBIG(r) Participant and
You.  "You" (or "Your") shall mean a person or an entity, and all other entities
that control, are controlled by, or are under common control with the entity.
"Control" for purposes of this definition means (i) the direct or indirect power
to cause the direction or management of such entity, whether by contract or
otherwise, or (ii) ownership of fifty percent (50%) or more of the outstanding
shares, or (iii) beneficial ownership of such entity.

License.  Provided that You agree to the conditions described below, caBIG(r)
Participant grants You a non-exclusive, worldwide, perpetual, fully-paid-up,
no-charge, irrevocable, transferable and royalty-free right and license in its
rights in the caBIG(r) Software, including any copyright or patent rights therein,
to (i) use, install, disclose, access, operate, execute, reproduce, copy,
modify, translate, market, publicly display, publicly perform, and prepare
derivative works of the caBIG(r) Software in any manner and for any purpose, and
to have or permit others to do so; (ii) make, have made, use, practice, sell,
and offer for sale, import, and/or otherwise dispose of caBIG(r) Software (or
portions thereof); (iii) distribute and have distributed to and by third parties
the caBIG(r) Software and any modifications and derivative works thereof; and (iv)
sublicense the foregoing rights set out in (i), (ii) and (iii) to third parties,
including the right to license such rights to further third parties.  For sake
of clarity, and not by way of limitation, caBIG(r) Participant shall have no right
of accounting or right of payment from You or Your sublicensees for the rights
granted under this License.  This License is granted at no charge to You.  Your
downloading, copying, modifying, displaying, distributing or use of caBIG(r)
Software constitutes acceptance of all of the terms and conditions of this
Agreement.  If you do not agree to such terms and conditions, you have no right
to download, copy, modify, display, distribute or use the caBIG(r) Software.

1.  Your redistributions of the source code for the caBIG(r) Software must retain
the above copyright notice, this list of conditions and the disclaimer and
limitation of liability of Article 6 below.  Your redistributions in object code
form must reproduce the above copyright notice, this list of conditions and the
disclaimer of Article 6 in the documentation and/or other materials provided
with the distribution, if any.

2.  Your end-user documentation included with the redistribution, if any, must
include the following acknowledgment: "This product includes software developed
by the Ohio State University Research Foundation ("OSURF"), Argonne National
Laboratory ("ANL"), SemanticBits LLC ("SemanticBits"), and Ekagra Software
Technologies Ltd. ("Ekagra")."  If You do not include such end-user documentation,
You shall include this acknowledgment in the caBIG(r) Software itself, wherever
such third-party acknowledgments normally appear.

3.    You may not use the names "The Ohio State University Research
Foundation", "OSURF", "Argonne  National Laboratory", "ANL", "SemanticBits LLC",
"SemanticBits", "Ekagra Software Technologies Ltd.", "Ekagra", "The National
Cancer Institute", "NCI", "Cancer Biomedical Informatics Grid" or "caBIG(r)" to endorse or
promote products derived from this caBIG(r) Software.  This License does not
authorize You to use any trademarks, service marks, trade names, logos or
product names of either caBIG(r) Participant, NCI or caBIG(r), except as required to
comply with the terms of this License.

4.    For sake of clarity, and not by way of limitation, You may incorporate
this caBIG(r) Software into Your proprietary programs and into any third party
proprietary programs.  However, if You incorporate the caBIG(r) Software into
third party proprietary programs, You agree that You are solely responsible for
obtaining any permission from such third parties required to incorporate the
caBIG(r) Software into such third party proprietary programs and for informing
Your sublicensees, including without limitation Your end-users, of their
obligation to secure any required permissions from such third parties before
incorporating the caBIG(r) Software into such third party proprietary software
programs.  In the event that You fail to obtain such permissions, You agree to
indemnify caBIG(r) Participant for any claims against caBIG(r) Participant by such
third parties, except to the extent prohibited by law, resulting from Your
failure to obtain such permissions.

5.    For sake of clarity, and not by way of limitation, You may add Your own
copyright statement to Your modifications and to the derivative works, and You
may provide additional or different license terms and conditions in Your
sublicenses of modifications of the caBIG(r) Software, or any derivative works of
the caBIG(r) Software as a whole, provided Your use, reproduction, and
distribution of the Work otherwise complies with the conditions stated in this
License.

6.    THIS caBIG(r) SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED
WARRANTIES (INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR PURPOSE) ARE
DISCLAIMED.  IN NO EVENT SHALL THE OHIO STATE UNIVERSITY RESEARCH FOUNDATION
("OSURF"), ARGONNE NATIONAL LABORTORY ("ANL"), SEMANTICBITS LLC ("SEMANTICBITS"), AND
EKAGRA SOFTWARE TECHNOLOGIES LTD. ("EKAGRA") OR ITS AFFILIATES BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
caBIG(r) SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=head1 SEE ALSO

caGRID::CQL1::Association, caGRID::CQL1::Attribute, caGRID::CQL1::Group, 
caGRID::CQL1::Object, caGRID::CQL1::QueryModifier, caGRID::CQL1::Validator,
caGRID::CQL1::Schema, caGRID::Net::Request, caGRID::Net::Util,
caGRID::Transfer::Client, caGRID::Transfer::Schema.

=cut

use strict;
use LWP::UserAgent;
use XML::Writer;
use XML::LibXML::Reader;
use HTTP::Request::Common qw(:DEFAULT); 
use URI; 

=head2 new

 Title   : new
 Usage   :
 Function: Create a caGRID::Transfer::Client object
 Example : my $transfer = new caGRID::Transfer::Client()
 Returns : A caGRID::Transfer::Client object
 Args    : 

=cut

sub new
{
	my $that   = shift;
	my $class  = ref($that) || $that;
	
	my $self = {@_};
	
	
	bless( $self, $class );
	return $self;
}

our $soapNS = "http://schemas.xmlsoap.org/soap/envelope/";
our $transferNS = "http://transfer.cagrid.org/TransferService/Context";
our $tdataNS = "http://transfer.cagrid.org/Transfer";
our $wsaNS = "http://schemas.xmlsoap.org/ws/2004/03/addressing";
our $resNS = "http://docs.oasis-open.org/wsrf/2004/06/wsrf-WS-ResourceLifetime-1.2-draft-01.xsd";

our %nss = (
	$soapNS => "soap",
	$transferNS => "t",
	$tdataNS => "data",
	$wsaNS => "wsa",
	$resNS => "res"
);

=head2 downloadData

 Title   : downloadData
 Usage   :
 Function: Download data from server
 Example :
 Returns : Content or an error
 Args    : First parameter: the value of Address element from above XML fragment,
		     second parameter: the value of TransferServiceContextResultsKey element
		     from above XML fragment

=cut

sub downloadData
{
	my $self = shift;
	my $url = shift;
	my $dataKey = shift;
	
	my $dataURL = requestDataURL($url, $dataKey);
	my $userAgent = LWP::UserAgent->new( agent => 'transfer perl client' );
	my $response = $userAgent->get($dataURL);
	dieOnError($response);
	return $response->content();

}

=head2 downloadDataToCB

 Title   : downloadDataToCB
 Usage   :
 Function: Download data from server to a code block. This function will be called for 
			  each chunk of the response content as it is received from the server
 Example :
 Returns : 1 or an error
 Args    : First parameter: the value of Address element from above XML fragment,
		     second parameter: the value of TransferServiceContextResultsKey element
		     from above XML fragment, third parameter: code block reference

=cut

sub downloadDataToCB
{
	my $self = shift;
	my $url = shift;
	my $dataKey = shift;
	my $cb = shift;
	
	my $dataURL = requestDataURL($url, $dataKey);
	my $userAgent = LWP::UserAgent->new( agent => 'transfer perl client' );
	my $response = $userAgent->get($dataURL, ":content_cb"=>$cb);
	dieOnError($response);
	1;
}

=head2 downloadDataToFile

 Title   : downloadDataToFile
 Usage   :
 Function: Download data from server to a file
 Example :
 Returns : 1 or an error
 Args    : First parameter: the value of Address element from above XML fragment,
		     second parameter: the value of TransferServiceContextResultsKey element
		     from above XML fragment, third parameters: a file to store the 
           downloaded content

=cut

sub downloadDataToFile
{
	my $self = shift;
	my $url = shift;
	my $dataKey = shift;
	my $file = shift;
	
	my $dataURL = requestDataURL($url, $dataKey);
	my $userAgent = LWP::UserAgent->new( agent => 'transfer perl client' );
	my $response = $userAgent->get($dataURL, ":content_file"=>$file);
	dieOnError($response);
	1;
}

=head2 uploadData

 Title   : uploadData
 Usage   : Upload data to server
 Function:
 Example :
 Returns : 1 or an error
 Args    : First parameter: the value of Address element from above XML fragment,
		     second parameter: the value of TransferServiceContextResultsKey element
			  from above XML fragment, third parameter: the content to be uploaded

=cut

sub uploadData
{
	my $self = shift;
	my $url = shift;
	my $dataKey = shift;
	my $content = shift;
	my $dataURL = requestDataURL($url, $dataKey);
	my $userAgent = LWP::UserAgent->new( agent => 'transfer perl client' );
	my $request = POST($dataURL, content_type => "application/octet-stream", 
							 content => $content);
	my $response = $userAgent->request($request);
	unless ( $response->is_success() ) 
	{
			die $response->message();
	}
	return 1;
		
}

=head2 uploadFile

 Title   : uploadFile
 Usage   : Upload data to server
 Function:
 Example :
 Returns : 1 or an error
 Args    : First parameter: the value of Address element from above XML fragment,
		     second parameter: the value of TransferServiceContextResultsKey element
			  from above XML fragment, third parameter: the file to be uploaded

=cut

sub uploadFile
{
	my $self = shift;
	my $url = shift;
	my $dataKey  =shift;
	my $file = shift;
	my $dataURL = requestDataURL($url, $dataKey);
	my $response = socketPost($dataURL, $file);
	return 1;
		
}

=head2 setStatus

 Title   : setStatus
 Usage   :
 Function: Set data status
 Example :
 Returns : 1 or an error
 Args    : First parameter: the value of Address element from above XML fragment,
		     second parameter: the value of TransferServiceContextResultsKey element
		     from above XML fragment, third parameter: status (available status are
			  $caGRID::Transfer::_STAGING and $caGRID::Transfer::_STAGED)

=cut

our $_STAGING = "Staging";
our $_STAGED = "Staged";

sub setStatus
{
	my $self = shift;
	my $url = shift;
	my $dataKey = shift;
	my $status = shift;
	
	my $xml = "";
	# Construct Request XML
	my $writer = new XML::Writer(
		OUTPUT => \$xml,

		# NEWLINES        => 1,
		NAMESPACES      => 1,
		PREFIX_MAP      => \%nss,
		DATA_MODE       => 1,
		DATA_INDENT     => 2,
		ENCONDING       => 'utf-8',
		FORCED_NS_DECLS => [ $soapNS, $transferNS, $wsaNS]
	);
	$writer->xmlDecl();
	$writer->startTag( [ $soapNS, "Envelope" ] );
	
	#---------header
	$writer->startTag( [ $soapNS, "Header" ] );
	
	$writer->startTag([$wsaNS, "To"], [$soapNS, "mustUnderstand"]=>"0");
	$writer->characters($url);
	$writer->endTag();
	
	$writer->startTag([$transferNS, "TransferServiceContextResultsKey"]);
	$writer->characters($dataKey);
	$writer->endTag();
	
	$writer->endTag();
	
	#--------body
	$writer->startTag( [ $soapNS, "Body" ] );
	$writer->startTag([$transferNS, "SetStatusRequest"]);
	$writer->startTag([$transferNS, "status"]);
	$writer->startTag([$tdataNS, "Status"]);
	$writer->characters($status);
	$writer->endTag();
	
	$writer->endTag();
	$writer->endTag();
	$writer->endTag();
	
	
	$writer->endTag();
	$writer->end();
	
	my $SOAPaction = "http://transfer.cagrid.org/TransferService/Context/SetStatusRequest";
	my $userAgent  = LWP::UserAgent->new( agent => 'transfer perl client' );
	my $request    = POST ($url);
	$request->content_type("text/xml; charset=utf-8");
	$request->header( SOAPAction => $SOAPaction );
	$request->content($xml);
	$request->content_length(length($xml));
	my $response = $userAgent->request($request);
	dieOnError($response);
	return 1;
	
}

=head2 destroy

 Title   : destroy
 Usage   :
 Function: Destroy data in server resource context (not from persistent store)
 Example :
 Returns : 1 or an error
 Args    : First parameter: the value of Address element from above XML fragment,
		     second parameter: the value of TransferServiceContextResultsKey element
		     from above XML fragment.

=cut

sub destroy
{
	my $self = shift;
	my $url = shift;
	my $dataKey = shift;
	
	my $xml = "";
	# Construct Request XML
	my $writer = new XML::Writer(
		OUTPUT => \$xml,

		#NEWLINES        => 1,
		NAMESPACES      => 1,
		PREFIX_MAP      => \%nss,
		DATA_MODE       => 1,
		DATA_INDENT     => 2,
		ENCONDING       => 'utf-8',
		FORCED_NS_DECLS => [ $soapNS, $transferNS, $wsaNS]
	);
	$writer->xmlDecl();
	$writer->startTag( [ $soapNS, "Envelope" ] );
	
	#---------header
	$writer->startTag( [ $soapNS, "Header" ] );
	
	$writer->startTag([$wsaNS, "To"], [$soapNS, "mustUnderstand"]=>"0");
	$writer->characters($url);
	$writer->endTag();
	
	$writer->startTag([$transferNS, "TransferServiceContextResultsKey"]);
	$writer->characters($dataKey);
	$writer->endTag();
	
	$writer->endTag();
	
	#--------body
	$writer->startTag( [ $soapNS, "Body" ] );
	$writer->emptyTag([$resNS, "Destroy"]);
	$writer->endTag();
	
	
	$writer->endTag();
	$writer->end();
	
	my $SOAPaction = "http://transfer.cagrid.org/TransferService/Context/SetStatusRequest";
	my $userAgent  = LWP::UserAgent->new( agent => 'transfer perl client' );
	my $request    = POST ($url);
	$request->content_type("text/xml; charset=utf-8");
	$request->header( SOAPAction => $SOAPaction );
	$request->content($xml);
	$request->content_length(length($xml));
	my $response = $userAgent->request($request);
	dieOnError($response);
	return 1;

}

=head2 requestDataURL

 Title   : requestDataURL
 Usage   :
 Function: Private method
 Example :
 Returns : Content or an error
 Args    :

=cut

sub requestDataURL
{
	my $url = shift;
	my $dataKey = shift;
	my $xml = "";

	# Construct Request xml
	my $writer = new XML::Writer (
		OUTPUT => \$xml,
		# NEWLINES        => 1,
		NAMESPACES      => 1,
		PREFIX_MAP      => \%nss,
		DATA_MODE       => 1,
		DATA_INDENT     => 2,
		ENCONDING       => 'utf-8',
		FORCED_NS_DECLS => [ $soapNS, $transferNS, $wsaNS]
	);

	$writer->xmlDecl();
	$writer->startTag( [ $soapNS, "Envelope" ] );
	
	#---------header
	$writer->startTag( [ $soapNS, "Header" ] );
	$writer->startTag([$wsaNS, "To"], [$soapNS, "mustUnderstand"]=>"0");
	$writer->characters($url);
	$writer->endTag();
	
	$writer->startTag([$transferNS, "TransferServiceContextResultsKey"]);
	$writer->characters($dataKey);
	$writer->endTag();
	
	$writer->endTag();
	
	#--------body
	$writer->startTag( [ $soapNS, "Body" ] );
	$writer->emptyTag([$transferNS, "GetDataTransferDescriptorRequest"]);
	$writer->endTag();
	
	
	$writer->endTag();
	$writer->end();
	
	my $SOAPaction = "http://transfer.cagrid.org/TransferService/Context/GetDataTransferDescriptorRequest";
	my $userAgent  = LWP::UserAgent->new( agent => 'transfer perl client' );
	my $request    = POST ($url);
	$request->content_type("text/xml; charset=utf-8");
	$request->header( SOAPAction => $SOAPaction );
	$request->content($xml);
	$request->content_length(length($xml));
	my $response = $userAgent->request($request);
	
	dieOnError($response);
	
	return extractDataURL($response->content());
	
}

=head2 extractDataURL

 Title   : extractDataURL
 Usage   :
 Function:
 Example :
 Returns : URL or an error
 Args    : A XML::LibXML::Reader

=cut

sub extractDataURL
{
    my $resp = shift;
    my $reader = new XML::LibXML::Reader(string => $resp);
    my $url = 0;
    while ( $reader->read ) {
        if (
            $reader->localName() eq "url"
            && $reader->nodeType() ==
            XML_READER_TYPE_ELEMENT
            )
        {
            $url=1;
        }
        if ($reader->nodeType() ==
            XML_READER_TYPE_TEXT && $url==1 )
        {
            $url = $reader->value();
            $reader->close();
            return $url;
        }
    }
    die "No URL element is found\n";
}

=head2 dieOnError

 Title   : dieOnError
 Usage   :
 Function:
 Example :
 Returns : An error if there is an error
 Args    : An HTTP::Response

=cut

sub dieOnError
{
	my $response = shift;
	unless ( $response->is_success() ) {
		if ($response->header("Content-Type")=~/text\/xml/)
		{
			die extractFault($response->content());
		} else
		{
			die $response->message();
		}
	}
}

=head2 extractFault

 Title   : extractFault
 Usage   :
 Function:
 Example :
 Returns : An error string
 Args    : An HTTP::Response and a XML::LibXML::Reader

=cut

sub extractFault
{
	my $resp = shift;
	my $reader = new XML::LibXML::Reader(string => $resp);
   while ( $reader->read ) {
        if (
            $reader->localName() eq "faultstring"
            && $reader->nodeType() ==
            XML_READER_TYPE_ELEMENT
            )
        {
            my $fault = $reader->readInnerXml();
            $reader->close();
            return $fault;
        }
   }
    return "Unknown error";
}

use Net::HTTP;

=head2 socketPost

 Title   : socketPost
 Usage   :
 Function:
 Example :
 Returns : File content
 Args    : A URL and a file name

=cut

sub socketPost
{
	my $dataURL = shift;
	my $uri = new URI($dataURL);
	my $file = shift;
	open(FH, "<$file") or die "can not open $file for reading";
	
 	my $s = Net::HTTP->new(Host => $uri->host(), PeerPort=>$uri->port()) || die $@;
	
	$s->write_request("POST", 
							$uri->path_query(),
							'User-Agent' => "tranfser perl client", 
							"Content-Type"=>"application/octet-stream",
							"Transfer-Encoding"=> "chunked"
						  );
	 
	my $buf;
	while (read(FH, $buf, 2048))
	  {
		  $s->write_chunk($buf);
	  }
 	$s->write_chunk_eof();
 	close(FH);
 	
 	my($code, $mess, %h) = $s->read_response_headers;
	my $content = "";
 	while (1) 
	  {
		  my $n = $s->read_entity_body($buf, 1024);
		  die "read failed: $!" unless defined $n;
		  $content = $content . $buf;
		  last unless $n;
	  }
 	if ($code!=200)
	  {
		  die $mess."\n".$content;
	  }
 	return $content
}

1;
