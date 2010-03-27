# $Id: CQL1.pm 144 2010-03-27 19:12:06Z osborneb $
package caGRID::CQL1;

=head1 NAME

caGRID::CQL1 - Construct and send a CQL XML request

=head1 SYNOPSIS

  use caGRID::CQL1;
  use caGRID::CQL1::Object;
  use caGRID::CQL1::Group;
  use caGRID::CQL1::Attribute;
  use caGRID::CQL1::Association;
  use caGRID::CQL1::QueryModifier;

  $url = 'http://141.161.25.20:8080/wsrf/services/cagrid/GridPIR';

  # construct the query
  $obj = new caGRID::CQL1::Object();
  $obj->name("edu.georgetown.pir.domain.ProteinSequence");

  $assoc = new caGRID::CQL1::Association();
  $assoc->name("edu.georgetown.pir.domain.Protein");
  $assoc->rolename("protein");

  my $attr1 = new caGRID::CQL1::Attribute();
  $attr1->name("uniprotkbPrimaryAccession");
  $attr1->value("P05067");
  $attr1->predicate($caGRID::CQL1::Attribute::_EQUAL_TO);

  $assoc->attribute($attr1);

  $attr2 = new caGRID::CQL1::Attribute();
  $attr2->name("id");
  $attr2->value("P05067");
  $attr2->predicate($caGRID::CQL1::Attribute::_EQUAL_TO);

  $grp = new caGRID::CQL1::Group();
  $grp->op($caGRID::CQL1::Group::_LOGIC_OR);
  $grp->operands($assoc, $attr2);

  $obj->group($grp);

  $mod = new caGRID::CQL1::QueryModifier();
  $mod->attributeNames("length");
  $mod->attributeNames("id");
  $mod->attributeNames("value");

  # send the request, receive the data
  $cql = caGRID::CQL1->new;
  $response = $cql->request($url, $obj, $mod);

=head1 DESCRIPTION

caGrid is a service-oriented platform that supports cutting-edge collaborative 
science by providing the tools for organizations to integrate data silos, securely 
share data and compose analysis pipelines. caGrid supports e-Science initiatives in 
basic, translational, and clinical research. A major focus of caGRID at the 
moment is cancer research, and the publicly available data offered by caGRID currently 
is concerned with proteins and genes and experiments on proteins and genes as they relate 
to cancer.

The modules in caGRID-CQL1 are dedicated to constructing, validating, and sending CQL 
queries to the public Services in caGRID. CQL is the structured XML query 
language used in caGRID. For more information please see L<http://cagrid.org>.

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
caGRID::Transfer::Client, caGRID::CQL1.

=cut

use strict;
use XML::Writer;
use XML::LibXML::Reader;

our $VERSION = 1.0.1;

our $dataNS  = "http://gov.nih.nci.cagrid.data/DataService";
our $queryNS = "http://CQL.caBIG/1/gov.nih.nci.cagrid.CQLQuery";
our $soapNS  = "http://schemas.xmlsoap.org/soap/envelope/";
our $resultNS = "http://CQL.caBIG/1/gov.nih.nci.cagrid.CQLResultSet";

our %nss   = (
	$soapNS  => "",
	$dataNS  => "dat",
	$queryNS => "ns1"
);

=head2 new

 Title   : new
 Usage   : 
 Function: Create a caGRID::CQL1 object
 Example : my $obj = caGRID::CQL1->new()
 Returns : A caGRID::CQL1 object
 Args    : -debug => 1: if debug is true, the requested XML is printed to console,
           -timeout => 5: timeout query if the request did not return in 5 seconds 
=cut

sub new {
   my ($class,@args) = @_;

   my $self = {};

   bless $self, $class;
   $self->_rearrange(@args);
   return $self;
}


=head2 request

 Title   : request
 Usage   :
 Function: Send the query the server. If the HTTP request fails this method dies with a
           HTTP error message	
 Example :
 Returns : SOAP XML from server
 Args    : 1st parameter: service URL, 2nd parameter: target object (instance of 
           CQL1::Object), optional 3nd parameter: a Query modifier

=cut

sub request {
	my $self   = shift;
	my $url    = shift;
	my $target   = shift;
	my $modifier = shift;

	my $timeout;

	my $xml = $self->toXML( $target, $modifier );
	if ( $self->{debug} )
	{
	    print "-------------query--------------\n";
	    print $xml;
	    print "-------------end of query-------\n";
	}
	
	$timeout = $self->{timeout} if $self->{timeout};

	my $response = caGRID::Net::Request::request($xml,$url,$timeout);

	$response;
}

=head2 getResultCollection

 Title   : getResultCollection
 Usage   :
 Function: Position the parser to the CQLQueryResultCollection element
           Die with error message if the CQLQueryResultCollection element can  
           not be found
 Example :
 Returns : Return the positioned reader
 Args    : A XML::LibXML::Reader object

=cut

sub getResultCollection {
	my $self   = shift;
	my $reader = shift;
	while ( $reader->read ) {
		if ( $reader->localName() eq "CQLQueryResultCollection"
			  && $reader->namespaceURI() eq $resultNS
			  && $reader->nodeType() == XML_READER_TYPE_ELEMENT
			)
		  {
			  return $reader;
		  }
	}
	
	die "CQLQueryResultCollection is not found";

}

=head2 getCount

 Title   : getCount
 Usage   :
 Function: Return the count value
 Example :
 Returns :
 Args    : An instance of XML::LibXML::Reader

=cut

sub getCount
{
	my $self = shift;
	my $reader = shift;
	while ( $reader->read ) {
		if ($reader->localName() eq "CountResult"
			&& $reader->namespaceURI() eq $resultNS
			&& $reader->nodeType() ==
			XML_READER_TYPE_ELEMENT)
			{
				return $reader->getAttribute("count");
			}
	}
	
	die "no CountResult element is found";
}

=head2 getTargetClass

 Title   : getTargetClass
 Usage   :
 Function: Return the targetClass from query result
 Example :
 Returns :
 Args    :  An instance of XML::LibXML::Reader positioned to CQLQueryResultCollection

=cut

sub getTargetClass
{
	my $self = shift;
	my $reader = shift;
	return $reader->getAttribute("targetClassname");
}

=head2 getAttributeResultAsHashRef

 Title   : getAttributeResultAsHashRef
 Usage   :
 Function: Return all the AttributeResult as a hash reference
 Example :
 Returns :
 Args    : An instance of XML::LibXML::Reader positioned to CQLQueryResultCollection

=cut

sub getAttributeResultAsHashRef
{
	my $self = shift;
	my $reader = shift;
	my %hashref = ();

	while ( $reader->read ) {
		if ( $reader->localName() eq "Attribute"
			&& $reader->namespaceURI() eq $resultNS
			&& $reader->nodeType() == XML_READER_TYPE_ELEMENT)
			{
				$hashref{$reader->getAttribute("name")} = $reader->getAttribute("value");
			}
	}
	return \%hashref;
	
}


=head2 getElementAttributesAsHashRef

 Title   : getElementAttributesAsHashRef
 Usage   :
 Function: Return the all attributes for an XML element as a reference
 Example :
 Returns : Hash reference
 Args    : An instance of XML::LibXML::Reader positioned to an XML element

=cut

sub getElementAttributesAsHashRef
{
	my $self = shift;
	my $reader = shift;
	my %hashref = ();
	if ($reader-> moveToFirstAttribute()) 
	  {
		  do 
			 {
				 $hashref{$reader->name()} = $reader->value();
			 } while ($reader-> moveToNextAttribute());
		  $reader-> moveToElement();
	  }
	
	return \%hashref;
}



=head2 getFirstChildElement

 Title   : getFirstChildElement
 Usage   :
 Function: Position reader to the first child XML element
 Example :
 Returns :
 Args    : An instance of XML::LibXML::Reader positioned to an XML element

=cut

sub getFirstChildElement
{
	my $self = shift;
	my $reader = shift;
	
	while ($reader->read() && $reader->nodeType() != XML_READER_TYPE_ELEMENT)
	  {
		  #do nothing
	  }

}


=head2 getAttributeResultAsArrayRef

 Title   : getAttributeResultAsArrayRef
 Usage   :
 Function: Return all the AttributeResult as array reference
 Example :
 Returns :
 Args    : An instance of XML::LibXML::Reader positioned to CQLQueryResultCollection

=cut

sub getAttributeResultAsArrayRef
{
	my $self = shift;
	my $reader = shift;
	my @arr;

	while ( $reader->read ) {
		if ($reader->localName() eq "Attribute"
			&& $reader->namespaceURI() eq $resultNS
			&& $reader->nodeType() ==
			XML_READER_TYPE_ELEMENT)
			{
				push @arr,$reader->getAttribute("value");
			}
	}
	return \@arr;
	
}

=head2 toXML

 Title   : toXML
 Usage   :
 Function: Private method to write CQL XML
 Example :
 Returns : CQL XML
 Args    : A Target and any QueryModifier

=cut

sub toXML {
	my $self   = shift;
	my $target = shift;
	my $mod  = shift;

	my $ret  = "";
	my $writer = new XML::Writer(
		OUTPUT          => \$ret,
		NEWLINES        => 1,
		NAMESPACES      => 1,
		PREFIX_MAP      => \%nss,
		DATA_MODE       => 1,
		DATA_INDENT     => 2,
		ENCONDING       => 'utf-8',
		FORCED_NS_DECLS => [ $soapNS, $dataNS ]
	);
	$writer->xmlDecl();
	$writer->startTag( [ $soapNS, "Envelope" ] );
	$writer->emptyTag( [ $soapNS, "Header" ] );
	$writer->startTag( [ $soapNS, "Body" ] );
	$writer->startTag( [ $dataNS, "QueryRequest" ] );
	$writer->startTag( [ $dataNS, "cqlQuery" ] );

	$writer->forceNSDecl($queryNS);
	$writer->startTag( [ $queryNS, "CQLQuery" ], );

	#target
	$writer->startTag( [ $queryNS, "Target" ], "name" => $target->name() );
	$self->printObjChildren( $writer, $target );

	$writer->endTag();

	if ($mod) {
		$writer->startTag( [ $queryNS, "QueryModifier" ], 
				  "countOnly" => ($mod->countOnly() ? "true" : "false") );
		
		if ($mod->distinctAttribute())
		{
			$writer->startTag([$queryNS, "DistinctAttribute"]);
			$writer->characters($mod->distinctAttribute());
			$writer->endTag();
		}
		if ($mod->attributeNames())
		{
			foreach my $attrName ($mod->attributeNames())
			{
				$writer->startTag([$queryNS, "AttributeNames"]);
				$writer->characters($attrName);
				$writer->endTag();
			}
		}
		$writer->endTag();
	}
	$writer->endTag();
	$writer->endTag();
	$writer->endTag();
	$writer->endTag();
	$writer->endTag();

	$writer->end();
	return $ret;

}

=head2 printObjChildren

 Title   : printObjChildren
 Usage   :
 Function: Print any Association, Attribute, or Group objects
 Example :
 Returns :
 Args    : An XML Writer, an Object

=cut

sub printObjChildren {
	my $self   = shift;
	my $writer = shift;
	my $obj  = shift;
	if ( $obj->association() ) {
		$self->printAssoc( $writer, $obj->association() );
	}
	elsif ( $obj->attribute() ) {
		$self->printAttr( $writer, $obj->attribute() );
	}
	elsif ( $obj->group() ) {
		$self->printGroup( $writer, $obj->group() );
	}

}

=head2 printAttr

 Title   : printAttr
 Usage   :
 Function: Print any Attribute objects
 Example :
 Returns :
 Args    : An XML Writer, an Attribute

=cut

sub printAttr {
	my $self   = shift;
	my $writer = shift;
	my $attr   = shift;
	$writer->emptyTag(
		[ $queryNS, "Attribute" ],
		"name"    => $attr->name,
		"predicate" => $attr->predicate(),
		"value"   => $attr->value()
	);

}

=head2 printAssoc

 Title   : printAssoc
 Usage   :
 Function: Print any Association objects
 Example :
 Returns :
 Args    : An XML Writer, an Association object

=cut

sub printAssoc {
	my $self   = shift;
	my $writer = shift;
	my $assoc  = shift;
	$writer->startTag(
		[ $queryNS, "Association" ],
		"name"   => $assoc->name(),
		"roleName" => $assoc->rolename()
	);
	$self->printObjChildren( $writer, $assoc );
	$writer->endTag();
}

=head2 printGroup

 Title   : printGroup
 Usage   :
 Function: Print any Group objects
 Example :
 Returns :
 Args    : An XML Writer, a Group object

=cut

sub printGroup {
	my $self   = shift;
	my $writer = shift;
	my $grp  = shift;

	$writer->startTag( [ $queryNS, "Group" ], "logicRelation" => $grp->op() );

	foreach my $obj ( $grp->operands() ) {
		if ( $grp->isAssociation($obj) ) {
			$self->printAssoc( $writer, $obj );
		}
		elsif ( $grp->isAttribute($obj) ) {
			$self->printAttr( $writer, $obj );
		}
		else {
			$self->printGroup( $writer, $obj );
		}
	}
	$writer->endTag();

}

=head2 extractFault

 Title   : extractFault
 Usage   :
 Function:
 Example :
 Returns : Error string
 Args    :

=cut

sub extractFault
{
	my $resp = shift;
	my $reader = new XML::LibXML::Reader(string => $resp);

   while ( $reader->read ) {
    if ($reader->localName() eq "faultstring"
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

=head2 _rearrange

 Title   : _rearrange
 Usage   :
 Function: Initialize with arguments to new()
 Example :
 Returns : 
 Args    : Optional, parameters with -

=cut

sub _rearrange {
   my $self = shift;
   my $key;

   while( @_ ) {
      ($key = shift) =~ s/\055//;
      $self->{$key} = shift;
   }
}

1;
