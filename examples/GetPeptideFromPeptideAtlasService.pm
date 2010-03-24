#-*-Perl-*-
# $Id: GetPeptideFromPeptideAtlasService.pm 100 2010-02-18 16:35:03Z osborneb $
package GetPeptideFromPeptideAtlasService;

use strict;
use caGRID::CQL::Attribute;
use caGRID::CQL::Object;
use caGRID::CQL::QueryModifier;
use caGRID::CQL;
use XML::Simple;

use constant HOST => 'informatics.systemsbiology.net';
use constant URL  => 'http://' . HOST . ':80/wsrf/services/cagrid/PeptideAtlasService';
use constant NAME => 'org.systemsbiology.peptideatlas.Peptide';

sub new {
	my $that = shift;
	my $class = ref($that) || $that;

	my $self = {@_};

	bless( $self, $class );
	return $self;
}

sub GetPeptide {
	my ($self,$id) = @_;

	die "No identifier" if ( ! $id );

	my $obj = new caGRID::CQL::Object();
	$obj->name(NAME);

	my $attr = new caGRID::CQL::Attribute();
	$attr->name("id");
	$attr->value($id);
	$attr->predicate($caGRID::CQL::Attribute::_EQUAL_TO);

	$obj->attribute($attr);

	my $mod = new caGRID::CQL::QueryModifier();
	$mod->countOnly(0);

	my $cql = new caGRID::CQL(-debug => 1);
	my $response = $cql->query(URL, $obj, $mod);

	my $data = XMLin($response);

	$data;
}

1;
