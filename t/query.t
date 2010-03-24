#-*-Perl-*-
# $Id: query.t 130 2010-03-24 14:23:09Z osborneb $

use strict;
use lib "./lib";

BEGIN: {
	eval { require Test::More; };
	if ( $@ ) {
		use lib 't/lib';
	}
	use Test::More tests => 34;

	use_ok('caGRID::CQL1::Attribute');
	use_ok('caGRID::CQL1::Object');
	use_ok('caGRID::CQL1::Association');
	use_ok('caGRID::CQL1::Group');
	use_ok('caGRID::CQL1::QueryModifier');
	use_ok('caGRID::CQL1');
	use_ok('caGRID::Net::Util');
	use_ok('caGRID::Net::Request');
	use_ok('caGRID::CQL1::Validator');

}

use XML::LibXML::Reader;

my ($obj, $attr, $assoc, $grp, $cql, $response, $mod, $result, 
	 $reader, $targetClass, $attrRef, $host, $url, $xml, $http_result);

# Timeout for the Request
my $timeout = 480;

$host = 'cabiogrid40.nci.nih.gov';
$url = "http://$host:80/wsrf/services/cagrid/CaBIO40GridSvc";

#-------------association query, distinct attribute modifier
$obj = caGRID::CQL1::Object->new();
$obj->name("gov.nih.nci.cabio.domain.Gene");

$assoc = caGRID::CQL1::Association->new();
$assoc->name("gov.nih.nci.cabio.domain.Protein");
$assoc->rolename("proteinCollection");
$obj->association($assoc);

my $name = $assoc->name;
#-------------------test
is('gov.nih.nci.cabio.domain.Protein', $name,"name() sets correctly");

my $role = $assoc->rolename;
#-------------------test
is('proteinCollection', $role,"rolename() sets correctly");

my $ref = $obj->association;
#-------------------test
is('caGRID::CQL1::Association', ref($ref),"association() sets correctly");

my $assoc1 = caGRID::CQL1::Association->new();
$assoc1->name("gov.nih.nci.cabio.domain.Taxon");
$assoc1->rolename("taxonCollection");
$assoc->association($assoc1);

$attr = caGRID::CQL1::Attribute->new();
$attr->name("commonName");
$attr->value("mouse");
$attr->predicate($caGRID::CQL1::Attribute::_EQUAL_TO);
$assoc1->attribute($attr);

$ref = $assoc1->attribute;
#-------------------test
is('caGRID::CQL1::Attribute', ref($ref),"attribute() sets correctly");

$mod = caGRID::CQL1::QueryModifier->new();
$mod->distinctAttribute('symbol');

$cql = caGRID::CQL1->new();    

$xml = $cql->toXML($obj, $mod);
$xml = extractRequest($xml);
#-------------------test
is(1, validateQueryXml($xml),"validate caBIO query");

$http_result = testHTTP($host);

SKIP: {
	skip "Can not connect to server $host for testing", 1 if ! $http_result;

	$response = $cql->query($url, $obj, $mod);

	$reader = XML::LibXML::Reader->new(string => $response);
	$reader = $cql->getResultCollection($reader);

	my $attrRef = caGRID::CQL1->getAttributeResultAsArrayRef($reader);

	#------------test 
	cmp_ok( $#{$attrRef}, '>', 100, "association query and distinct attribute modifier");

}

$host = 'informatics.systemsbiology.net';
$url = "http://$host:80/wsrf/services/cagrid/PeptideAtlasService";

$obj = caGRID::CQL1::Object->new();
$obj->name("org.systemsbiology.peptideatlas.Peptide");
    
$attr = caGRID::CQL1::Attribute->new();
$attr->name("id");

#-------------------test
is('id', $attr->name(),"setting Attribute name");

$attr->value("7");

#-------------------test
is(7, $attr->value(),"setting Attribute value");

$attr->predicate($caGRID::CQL1::Attribute::_EQUAL_TO);

#-------------------test
is('EQUAL_TO', $attr->predicate(),"setting Attribute predicate");

$obj->attribute($attr);
    
$mod = caGRID::CQL1::QueryModifier->new();
$mod->distinctAttribute('length');

$cql = caGRID::CQL1->new(-debug => 1);    

$xml = $cql->toXML($obj, $mod);
$xml = extractRequest($xml);
#-------------------test
is(1, validateQueryXml($xml),"validate PeptideAtlasService query");

$http_result = testHTTP($host);

SKIP: {
	skip "Can not connect to server $host for testing", 1 if ! $http_result;

	$response = $cql->query($url, $obj, $mod);

	$reader = XML::LibXML::Reader->new(string => $response);
	$result = $cql->getResultCollection($reader);

	my $attrRef = caGRID::CQL1->getAttributeResultAsArrayRef($reader);

	#-------------------test 
	is($attrRef->[0], 21, "attribute length from PeptideAtlasService");
}

$host = '141.161.25.20';
$url = "http://$host:8080/wsrf/services/cagrid/GridPIR";

# $http_result = testHTTP($host);

SKIP: {
	# skip "Can not connect to server $host for testing", 4 if ! $http_result;

	#---------------attribute query, count modifier.
	$obj = caGRID::CQL1::Object->new();
	$obj->name("edu.georgetown.pir.domain.ProteinSequence");
    
	$attr = caGRID::CQL1::Attribute->new();
	$attr->name("id");
	$attr->value("P05067");
	$attr->predicate($caGRID::CQL1::Attribute::_EQUAL_TO);
    
	$obj->attribute($attr);
    
	$mod = caGRID::CQL1::QueryModifier->new();
	$mod->countOnly(1);

	$cql = caGRID::CQL1->new(timeout => $timeout);    

	$xml = $cql->toXML($obj, $mod);
	$xml = extractRequest($xml);
	#-------------------test
	is(1, validateQueryXml($xml),"validate 1st GridPIR query");

	$response = $cql->query($url, $obj, $mod);

	$reader = XML::LibXML::Reader->new(string => $response);
	$result = $cql->getResultCollection($reader);

	my $count = caGRID::CQL1->getCount($result);

	#-------------------test 
	is($count, 1, "attribute query and count query modifier");

	#-------------association query, distinct attribute modifier
	$obj = caGRID::CQL1::Object->new();
	$obj->name("edu.georgetown.pir.domain.ProteinSequence");
	
	$assoc = caGRID::CQL1::Association->new();
	$assoc->name("edu.georgetown.pir.domain.Protein");
	$assoc->rolename("protein");
    
	$attr = caGRID::CQL1::Attribute->new();
	$attr->name("uniprotkbPrimaryAccession");
	$attr->value("P05067");
	$attr->predicate($caGRID::CQL1::Attribute::_EQUAL_TO);

	$name = $attr->name;
	#-------------------test
	is('uniprotkbPrimaryAccession', $name,"name() of Attribute sets correctly");

	my $val = $attr->value;
	#-------------------test
	is('P05067', $val,"value() sets correctly");

	$assoc->attribute($attr);

	$obj = caGRID::CQL1::Object->new();
	$obj->name("edu.georgetown.pir.domain.ProteinSequence");
	$obj->association($assoc);

	$mod = caGRID::CQL1::QueryModifier->new();
	$mod->distinctAttribute("length");

	$cql = caGRID::CQL1->new(timeout => $timeout);

	$xml = $cql->toXML($obj, $mod);
	$xml = extractRequest($xml);
	#-------------------test
	is(1, validateQueryXml($xml),"validate 2nd GridPIR query");

	$response = $cql->query($url, $obj, $mod);

	$reader = XML::LibXML::Reader->new(string => $response);
	$reader = $cql->getResultCollection($reader);

	my $attrRef = caGRID::CQL1->getAttributeResultAsHashRef($reader);

	#------------test 
	is($attrRef->{length}, 770, "association query and distinct attribute modifier");

	#------------attributeNames
	$obj = caGRID::CQL1::Object->new();
	$obj->name("edu.georgetown.pir.domain.ProteinSequence");
	
	$assoc = caGRID::CQL1::Association->new();
	$assoc->name("edu.georgetown.pir.domain.Protein");
	$assoc->rolename("protein");
    
	$attr = caGRID::CQL1::Attribute->new();
	$attr->name("uniprotkbPrimaryAccession");
	$attr->value("P05067");
	$attr->predicate($caGRID::CQL1::Attribute::_EQUAL_TO);

	$assoc->attribute($attr);

	$obj = caGRID::CQL1::Object->new();
	$obj->name("edu.georgetown.pir.domain.ProteinSequence");
	$obj->association($assoc);

	$mod = caGRID::CQL1::QueryModifier->new();
	$mod->attributeNames("length");
	$mod->attributeNames("id");
	$mod->attributeNames("value");

	#-------------------test
	is(3, $mod->attributeNames(),"attributeNames sets correctly");

	$cql = caGRID::CQL1->new(timeout => $timeout);

	$xml = $cql->toXML($obj, $mod);
	$xml = extractRequest($xml);
	#-------------------test
	is(1, validateQueryXml($xml),"validate 3rd GridPIR query");

	$response = $cql->query($url, $obj, $mod);

	$reader = XML::LibXML::Reader->new(string => $response);
	$reader = $cql->getResultCollection($reader);

	$attrRef = caGRID::CQL1->getAttributeResultAsHashRef($reader);

	#--------------test 
	is($attrRef->{id}, "P05067", "attributeNames modifier"); 

	#--------------Object result, no QueryModifier
	$obj = caGRID::CQL1::Object->new();
	$obj->name("edu.georgetown.pir.domain.ProteinSequence");
	
	$assoc = caGRID::CQL1::Association->new();
	$assoc->name("edu.georgetown.pir.domain.Protein");
	$assoc->rolename("protein");
    
	$attr = caGRID::CQL1::Attribute->new();
	$attr->name("uniprotkbPrimaryAccession");
	$attr->value("P05067");
	$attr->predicate($caGRID::CQL1::Attribute::_EQUAL_TO);

	$assoc->attribute($attr);

	$obj = caGRID::CQL1::Object->new();
	$obj->name("edu.georgetown.pir.domain.ProteinSequence");
	$obj->association($assoc);

	$cql = caGRID::CQL1->new(timeout => $timeout);

	$xml = $cql->toXML($obj);
	$xml = extractRequest($xml);
	#-------------------test
	is(1, validateQueryXml($xml),"validate 4th GridPIR query");

	$response = $cql->query($url, $obj);

	$reader = XML::LibXML::Reader->new(string => $response);
	$reader = $cql->getResultCollection($reader);

	caGRID::CQL1->getFirstChildElement($reader);
	caGRID::CQL1->getFirstChildElement($reader);
	$attrRef = caGRID::CQL1->getElementAttributesAsHashRef($reader);
	
	#--------------test 
	is($attrRef->{checksum}, "A12EE761403740F5", "object result query");

}

$host = 'cabiogrid42.nci.nih.gov';

$url = "http://$host:80/wsrf/services/cagrid/CaBIO42GridSvc";

#-------------association query, distinct attribute modifier
$obj = caGRID::CQL1::Object->new;
$obj->name('gov.nih.nci.cabio.domain.Library');

# Make inner group
my $attr1 = caGRID::CQL1::Attribute->new();
$attr1->name("histology");
$attr1->value("neoplasia");
$attr1->predicate($caGRID::CQL1::Attribute::_EQUAL_TO);

my $attr2 = caGRID::CQL1::Attribute->new();
$attr2->name("organ");
$attr2->value("lung");
$attr2->predicate($caGRID::CQL1::Attribute::_EQUAL_TO);

my $innergroup = caGRID::CQL1::Group->new();
$innergroup->op($caGRID::CQL1::Group::_LOGIC_AND);
$innergroup->operands($attr1,$attr2);

# Make association and put inner group inside
$assoc = caGRID::CQL1::Association->new();
$assoc->name("gov.nih.nci.cabio.domain.Tissue");
$assoc->rolename("tissue");

$assoc->group($innergroup);

$ref = $assoc->group;
#-------------------test
is('caGRID::CQL1::Group', ref($ref),"group() sets correctly");

# Make outer group
my $outergroup = caGRID::CQL1::Group->new();
$outergroup->op($caGRID::CQL1::Group::_LOGIC_AND);
$outergroup->operands($assoc);

$obj->group($outergroup);

$mod = caGRID::CQL1::QueryModifier->new();
$mod->distinctAttribute('description');

$cql = caGRID::CQL1->new();    

$xml = $cql->toXML($obj, $mod);
$xml = extractRequest($xml);

# Will NOT test for validity: it declared invalid but it works

$http_result = testHTTP($host);

SKIP: {
	skip "Can not connect to server $host for testing", 1 if ! $http_result;

	$response = $cql->query($url, $obj, $mod);

	$reader = XML::LibXML::Reader->new(string => $response);
	$reader = $cql->getResultCollection($reader);

	my $attrRef = caGRID::CQL1->getAttributeResultAsArrayRef($reader);

	#-------------------test 
	cmp_ok( $#{$attrRef}, '>', 1, "caBio query with Group");

}

$host = 'array.nci.nih.gov';

$url = "http://$host:80/wsrf/services/cagrid/CaArraySvc";

#-------------association query, distinct attribute modifier
$obj = caGRID::CQL1::Object->new->new();
$obj->name('gov.nih.nci.caarray.domain.project.Experiment');

# Make inner group
$attr = caGRID::CQL1::Attribute->new();
$attr->name("scientificName");
$attr->value("Homo sapiens");
$attr->predicate($caGRID::CQL1::Attribute::_EQUAL_TO);

$innergroup = caGRID::CQL1::Group->new();
$innergroup->op($caGRID::CQL1::Group::_LOGIC_AND);
$innergroup->operands($attr);

# Make association and put inner group inside
$assoc = caGRID::CQL1::Association->new();
$assoc->name("edu.georgetown.pir.Organism");
$assoc->rolename("organism");

$assoc->group($innergroup);

# Make outer group
$outergroup = caGRID::CQL1::Group->new();
$outergroup->op($caGRID::CQL1::Group::_LOGIC_AND);
$outergroup->operands($assoc);

$obj->group($outergroup);

$mod = caGRID::CQL1::QueryModifier->new();
$mod->countOnly(1);

$cql = caGRID::CQL1->new();    

$xml = $cql->toXML($obj, $mod);
$xml = extractRequest($xml);

$http_result = testHTTP($host);

SKIP: {
	skip "Can not connect to server $host for testing", 1 if ! $http_result;

	$response = $cql->query($url, $obj, $mod);

	$reader = XML::LibXML::Reader->new(string => $response);
	$result = $cql->getResultCollection($reader);

	my $count = caGRID::CQL1->getCount($result);

	#-------------------test 
	cmp_ok($count,'>', 100, "caArray query and count query modifier");

}

__END__


