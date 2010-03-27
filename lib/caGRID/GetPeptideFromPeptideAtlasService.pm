#-*-Perl-*-
# $Id: GetPeptideFromPeptideAtlasService.pm 143 2010-03-26 16:42:24Z osborneb $
package caGRID::GetPeptideFromPeptideAtlasService;

=head1 NAME

caGRID::GetPeptideFromPeptideAtlasService - an example to show how to use caGRID::CQL1

=head1 SYNOPSIS

 use caGRID::GetPeptideFromPeptideAtlasService;

 my $query = caGRID::GetPeptideFromPeptideAtlasService->new;

 my $id = 7;

 my $peptide = $query->GetPeptide($id);

=head1 DESCRIPTION

This is a simple example of how to use the caGRID::CQL1 modules to create
other modules that scientists could easily use to retrieve data from caGRID.

=head1 AUTHOR

Jason Zhang, Brian Osborne

=head1 SEE ALSO

caGRID::CQL1::Association, caGRID::CQL1::Attribute, caGRID::CQL1::Group, 
caGRID::CQL1::Object, caGRID::CQL1::QueryModifier, caGRID::CQL1::Validator,
caGRID::CQL1::Schema, caGRID::Net::Request, caGRID::Net::Util,
caGRID::Transfer::Client, caGRID::CQL1.

=cut

use strict;
use caGRID::CQL1::Attribute;
use caGRID::CQL1::Object;
use caGRID::CQL1::QueryModifier;
use caGRID::CQL1;
use XML::Simple;

use constant URL  => 'http://informatics.systemsbiology.net:80/wsrf/services/cagrid/PeptideAtlasService';
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

	my $obj = caGRID::CQL1::Object->new;
	$obj->name(NAME);

	my $attr = caGRID::CQL1::Attribute->new;
	$attr->name("id");
	$attr->value($id);
	$attr->predicate($caGRID::CQL1::Attribute::_EQUAL_TO);

	$obj->attribute($attr);

	my $cql = caGRID::CQL1->new;

	my $response = $cql->query(URL, $obj);

	my $data = XMLin($response);

	$data;
}

1;

__END__

