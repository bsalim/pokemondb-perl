use strict;
use warnings;
use DBI;
use Try::Tiny;
use ENV::Util -load_dotenv;

# DB details
my $dbname = $ENV{DB_NAME};
my $host = $ENV{DB_HOST};
my $port = $ENV{DB_PORT};
my $user = $ENV{DB_USER};
my $password = $ENV{DB_PASS};

my $dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$host;port=$port", $user, $password, {
    PrintError => 0,
    RaiseError => 1,
    AutoCommit => 1,
}) or die "Error connecting to database: $DBI::errstr";


print "Prepare to create table `pokemon`\n";

my $create_table = <<'SQL';
CREATE TABLE IF NOT EXISTS pokemon (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    species VARCHAR(100) NOT NULL,
    types JSONB NOT NULL,
    stats JSONB NOT NULL
);
SQL

try {
    $dbh->do($create_table);
    print "Table pokemon created successfully.";
} catch {
    my $error = $_;
    die "Caught error: $error";
};
