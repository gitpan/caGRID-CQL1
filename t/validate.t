#-*-Perl-*-
# $Id: validate.t 135 2010-03-24 19:30:22Z osborneb $

use strict;
use lib "./lib";

BEGIN: {
	eval { require Test::More; };
	if ( $@ ) {
		use lib 't/lib';
	}
	use Test::More tests => 14;

	use_ok('caGRID::CQL1::Attribute');
	use_ok('caGRID::CQL1::Object');
	use_ok('caGRID::CQL1::Association');
	use_ok('caGRID::CQL1::Group');
	use_ok('caGRID::CQL1::QueryModifier');
	use_ok('caGRID::CQL1::Validator');
	use_ok('caGRID::CQL1');
	use_ok('caGRID::Net::Request');

}

use Data::Dumper;

my ($obj, $attr, $assoc, $grp, $mod, $xml);

my $cql = new caGRID::CQL1(debug => 1);

#---------------attribute query, count modifier.
$obj = new caGRID::CQL1::Object();
$obj->name("edu.georgetown.pir.domain.ProteinSequence");

$attr = new caGRID::CQL1::Attribute();
$attr->name("id");
$attr->value("P05067");
$attr->predicate($caGRID::CQL1::Attribute::_EQUAL_TO);

$obj->attribute($attr);

$mod = new caGRID::CQL1::QueryModifier();
$mod->countOnly(1);

$xml = $cql->toXML($obj, $mod);

#----------test 
is (1, defined($xml), "toXML()" );

$xml = extractRequest($xml);

#----------test 
is (1, defined($xml), "extractRequest()" );

#----------test 
is(1, validateQueryXml($xml), "validate attribute query with count modifier");

#-------------association query, distinct attribute modifier
$obj = new caGRID::CQL1::Object();
$obj->name("edu.georgetown.pir.domain.ProteinSequence");

$assoc = new caGRID::CQL1::Association();
$assoc->name("edu.georgetown.pir.domain.Protein");
$assoc->rolename("protein");

$attr = new caGRID::CQL1::Attribute();
$attr->name("uniprotkbPrimaryAccession");
$attr->value("P05067");
$attr->predicate($caGRID::CQL1::Attribute::_EQUAL_TO);

$assoc->attribute($attr);

$obj->association($assoc);

$mod = new caGRID::CQL1::QueryModifier();
$mod->distinctAttribute("length");

$xml = $cql->toXML($obj, $mod);
$xml = extractRequest($xml);
#------------test 
is(1, validateQueryXml($xml),"validate association query and distinct attribute modifier");


#------------group query, attributeNames
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

my $attr2 = new caGRID::CQL1::Attribute();
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

$xml = $cql->toXML($obj, $mod);
$xml = extractRequest($xml);
#--------------test 
is(1, validateQueryXml($xml),"validate group query and  attributeName modifier");


#--------------Object result
$obj = new caGRID::CQL1::Object();
$obj->name("edu.georgetown.pir.domain.ProteinSequence");

$attr = new caGRID::CQL1::Attribute();
$attr->name("id");
$attr->value("P05067");
$attr->predicate($caGRID::CQL1::Attribute::_EQUAL_TO);

$obj->attribute($attr);
$xml = $cql->toXML($obj);
$xml = extractRequest($xml);
#---------test 
is(1, validateQueryXml($xml),"validate object query with no modifier");
