use Test::More tests => 1;
BEGIN { use_ok('Net::Scan::Fork') };

use IO::Socket;

my $host = "127.0.0.1";

Net::Scan::Fork::settings(20,4,3,60);

foreach (1..100){
        Net::Scan::Fork::scan(\&scan,100,$_);
}

Net::Scan::Fork::wait_child;

exit(0);

sub scan{
	my $port = shift;

	my $connect = IO::Socket::INET->new(
		PeerAddr => $host,
		PeerPort => $port,
		Proto    => 'tcp',
		Timeout  => 0.1
	);

	if ($connect){
		close $connect;
		print "port $port tcp on $host is open\n";
	}
}
