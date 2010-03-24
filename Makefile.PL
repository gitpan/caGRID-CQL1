use ExtUtils::MakeMaker;

WriteMakefile( NAME          => 'caGRID-CQL1',
				   VERSION_FROM  => 'lib/caGRID/CQL1.pm',
				   ABSTRACT      => 'CQL and transfer service client for caGRID',
				   AUTHOR        => 'Jason Zhang, Brian Osborne',
				   PREREQ_PM     => { 'XML::Writer'      => '0.602',
											 'LWP'    => '5.800',
											 'XML::LibXML'   => '1.64',
											 'URI'     => '1.35',
										    'HTTP::Request::Common' => '0',
										    'Net::HTTP' => '0',
										    'LWP::Simple' => '0',
										  }
				  );

