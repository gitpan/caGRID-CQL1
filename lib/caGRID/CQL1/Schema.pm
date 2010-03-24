# $Id: Schema.pm 121 2010-03-22 19:29:29Z osborneb $
package caGRID::CQL1::Schema;

=head1 NAME

caGRID::CQL1::Schema - Hold the CQL1 schema

=head1 DESCRIPTION

 my $schema = getSchema();

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
use base 'Exporter';
our @EXPORT = qw( getSchema );

use constant CQLXSD =>
'<?xml version="1.0" encoding="UTF-8"?>
<!-- edited with XMLSpy v2005 rel. 3 U (http://www.altova.com) by David W. Ervin (The Ohio State University / Department of Biomedical Informatics) -->
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:cql="http://CQL.caBIG/1/gov.nih.nci.cagrid.CQLQuery" targetNamespace="http://CQL.caBIG/1/gov.nih.nci.cagrid.CQLQuery" elementFormDefault="qualified" attributeFormDefault="unqualified">
	<xsd:complexType name="Object">
		<xsd:annotation>
			<xsd:documentation>Object used as search criteria or target definition</xsd:documentation>
		</xsd:annotation>
		<xsd:choice>
			<xsd:element name="Attribute" type="cql:Attribute" minOccurs="0"/>
			<xsd:element name="Association" type="cql:Association" minOccurs="0"/>
			<xsd:element name="Group" type="cql:Group" minOccurs="0"/>
		</xsd:choice>
		<xsd:attribute name="name" type="xsd:string" use="required"/>
	</xsd:complexType>
	<xsd:complexType name="Association">
		<xsd:annotation>
			<xsd:documentation>Association to another Object</xsd:documentation>
		</xsd:annotation>
		<xsd:complexContent>
			<xsd:extension base="cql:Object">
				<xsd:attribute name="roleName" type="xsd:string" use="optional"/>
			</xsd:extension>
		</xsd:complexContent>
	</xsd:complexType>
	<xsd:complexType name="Attribute">
		<xsd:annotation>
			<xsd:documentation>Object Property element used as search criteria</xsd:documentation>
		</xsd:annotation>
		<xsd:attribute name="name" type="xsd:string" use="required"/>
		<xsd:attribute name="predicate" type="cql:Predicate" use="optional" default="EQUAL_TO"/>
		<xsd:attribute name="value" type="xsd:string" use="required"/>
	</xsd:complexType>
	<xsd:complexType name="Group">
		<xsd:annotation>
			<xsd:documentation>Binary joint</xsd:documentation>
		</xsd:annotation>
		<xsd:choice minOccurs="2" maxOccurs="unbounded">
			<xsd:element name="Association" type="cql:Association" maxOccurs="unbounded"/>
			<xsd:element name="Attribute" type="cql:Attribute" maxOccurs="unbounded"/>
			<xsd:element name="Group" type="cql:Group" maxOccurs="unbounded"/>
		</xsd:choice>
		<xsd:attribute name="logicRelation" type="cql:LogicalOperator" use="required"/>
	</xsd:complexType>
	<xsd:simpleType name="Predicate">
		<xsd:annotation>
			<xsd:documentation>Extensible predicate type for object properties</xsd:documentation>
		</xsd:annotation>
		<xsd:restriction base="xsd:string">
			<xsd:enumeration value="EQUAL_TO" id="equal_to"/>
			<xsd:enumeration value="NOT_EQUAL_TO" id="not_equal_to"/>
			<xsd:enumeration value="LIKE" id="like"/>
			<xsd:enumeration value="IS_NULL" id="is_null"/>
			<xsd:enumeration value="IS_NOT_NULL" id="is_not_null"/>
			<xsd:enumeration value="LESS_THAN" id="less_than"/>
			<xsd:enumeration value="LESS_THAN_EQUAL_TO" id="less_than_equal_to"/>
			<xsd:enumeration value="GREATER_THAN" id="greater_than"/>
			<xsd:enumeration value="GREATER_THAN_EQUAL_TO" id="greater_than_equal_to"/>
		</xsd:restriction>
	</xsd:simpleType>
	<xsd:simpleType name="LogicalOperator">
		<xsd:annotation>
			<xsd:documentation>Logical operators</xsd:documentation>
		</xsd:annotation>
		<xsd:restriction base="xsd:string">
			<xsd:enumeration value="AND"/>
			<xsd:enumeration value="OR"/>
		</xsd:restriction>
	</xsd:simpleType>
	<xsd:element name="CQLQuery">
		<xsd:annotation>
			<xsd:documentation>Top level of CQL queries</xsd:documentation>
		</xsd:annotation>
		<xsd:complexType>
			<xsd:sequence>
				<xsd:element name="Target" type="cql:Object">
					<xsd:annotation>
						<xsd:documentation>Defines the target data type of a CQL query</xsd:documentation>
					</xsd:annotation>
				</xsd:element>
				<xsd:element name="QueryModifier" type="cql:QueryModifier" minOccurs="0">
					<xsd:annotation>
						<xsd:documentation>Optionally modifies the returned results of the query</xsd:documentation>
					</xsd:annotation>
				</xsd:element>
			</xsd:sequence>
		</xsd:complexType>
	</xsd:element>
	<xsd:complexType name="QueryModifier">
		<xsd:annotation>
			<xsd:documentation>Modifies the returned data from the query</xsd:documentation>
		</xsd:annotation>
		<xsd:choice minOccurs="0">
			<xsd:element name="AttributeNames" type="xsd:string" maxOccurs="unbounded"/>
			<xsd:element name="DistinctAttribute" type="xsd:string"/>
		</xsd:choice>
		<xsd:attribute name="countOnly" type="xsd:boolean" use="required"/>
	</xsd:complexType>
</xsd:schema>';

=head2 getSchema

 Title   : getSchema
 Usage   : 
 Function: Return the CQL1 schema
 Example : $xml = getSchema()
 Returns : the CQL1 schema
 Args    : 

=cut

sub getSchema
{
	 my $xsd = CQLXSD;

    return $xsd;
}

1;
