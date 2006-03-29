package Net::Scan::Fork;

use 5.008006;
use strict;
use warnings;
use Carp;
use Sys::CpuLoad;

our $VERSION = '0.01';
$VERSION = eval $VERSION;

$| = 1;

my (@load,@pids);
my ($load,$pid,$npids);
my ($max_processes,$smax_processes,$nload,$sload,$sleep);

sub settings{
	($smax_processes,$nload,$sload,$sleep) = @_;
}

sub scan{

	my ($job,$max_processes,$host) = @_;
	my $oldmax_processes = $max_processes;

	@load = Sys::CpuLoad::load();
	$load = $load[0];
	if ($load > $nload){
		$max_processes = $smax_processes; 
		sleep $sleep;
	} else{
		$max_processes = $oldmax_processes;
	}

	$pid = fork();
	if ($pid>0){
		$npids++;
		if ($npids >= $max_processes){
			for (1..($max_processes)){
				my $wait_ret=wait();
				if ($wait_ret>0){
					$npids--;
				}
			}
		}
	} elsif (undef $pid){
		print " Fork error!\n";
		exit(0);
	} else{
		alarm 0;
		$job->($host);
		exit(0);
	}
}

sub wait_child{
	for (1..$npids){
		my $wt = wait();
	}
}

1;
__END__

=head1 NAME

Net::Scan::Fork - A simple way to manage fork processess.

=head1 SYNOPSIS

  use Net::Scan::Fork;

  bla bla
  bla bla

  Net::Scan::Fork::settings(20,4,3,60);

  foreach (@hosts){
    Net::Scan::Fork::scan(\&scan,100,$_);
  }

  Net::Scan::Fork::wait_child;

  exit(0);

  sub scan{
    bla bla
    bla bla
  }

=head1 DESCRIPTION

This module provides you a simple way to manage fork processess.
It would be useful in a multiprocess network/security/etc. scanner.

=head1 METHODS

=head2 settings 

Fork settings:

  Net::Scan::Fork::settings(20,4,3,60);

You can specify:

=over 2

=item B<new max processes>

set a new "max processes" value when the "critic cpu load" has been passed. 20 is a good value;

=item B<critic cpu load>

when the "critic cpu load" has been passed, the number of processes is decreased to "new max processes" and a sleep of seconds ("sleep time") takes place. 4 is a good value;

=item B<new cpu load>

is the new limit of the cpu load to check when the critic value has been passed. 3 is a good value;

=item B<sleep time>

sleep time (in seconds) when the "critic cpu load" value is exceeed; 60 is a good value;

=back

=head2 scan 

This function executes the code reference passed to it. 100 is the max number of processes value;

  Net::Scan::Fork::scan(\&scan,100,$ip);
  
=head2 wait_child 

Wait for all the processes which have been forked.

  Net::Scan::Fork::wait_child;

=head1 BUGS AND LIMITATIONS

A high value of processes could increase too much the cpu load and block the sistem :)
 
Please send me your feedback. 

=head1 SEE ALSO

L<Proc::Fork>
L<Parallel::ForkManager>

=head1 AUTHOR

Matteo Cantoni, E<lt>mcantoni@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

You may distribute this module under the terms of the Artistic license.
See Copying file in the source distribution archive.

Copyright (c) 2006, Matteo Cantoni

=cut
