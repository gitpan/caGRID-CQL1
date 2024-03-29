# $Id: Validator.pm 130 2010-03-24 14:23:09Z osborneb $
package caGRID::CQL1::Validator;

=head1 NAME

caGRID::CQL1::Validator - Validate CQL against the schema

=head1 DESCRIPTION

 # Validate
 $xml = $cql->toXML($obj, $mod);
 $xml = extractRequest($xml);
 $result = validateQueryXml($xml);

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
use Exporter;
use caGRID::CQL1::Schema;
our @ISA = qw(Exporter caGRID::CQL1::Schema);
our @EXPORT = qw(validateQueryXml);

use XML::LibXML;
use XML::LibXML::Reader;
use LWP::Simple;

=head2 validateQueryXml

 Title   : validateQueryXml
 Usage   : 
 Function: Validate CQL query against the schema
 Example : $result = validateQueryXml($xml)
 Returns : 1 if valid, 0 and the error if invalid
 Args    : debug => 1: If debug is true the requested XML is dumped to console.
           timeout => 5: timeout query if the request did not return in 5 seconds

=cut

sub validateQueryXml
{
    my $query = shift;

	 my $xsd = getSchema();

    my $parser = new XML::LibXML();
    my $doc = $parser->parse_balanced_chunk($query, "UTF-8");

    my $xmlschema = XML::LibXML::Schema->new( string => $xsd );
    
    eval { $xmlschema->validate( $doc ); };

    if ($@)
		{
			print STDERR $@;
			return 0;
		}
    return 1;
}

1;
