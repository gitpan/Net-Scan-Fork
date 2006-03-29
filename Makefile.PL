use 5.008006;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Net::Scan::Fork',
    VERSION_FROM      => 'lib/Net/Scan/Fork.pm',
    PREREQ_PM         => {
				Sys::CpuLoad => 0.02,
			},

    ($] >= 5.005 ?
      (ABSTRACT       => 'A simple way to manage fork processess.',
       AUTHOR         => 'Matteo Cantoni <mcantoni@cpan.org>') : ()),
);
