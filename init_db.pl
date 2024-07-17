use strict;
use warnings;
use DBI;
use Try::Tiny;

# DB details
my $dbname = 'pokemondb';
my $host = 'localhost';
my $port = '5432';
my $user = 'postgres';
my $password = 'XXXX';

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
    species VARCHAR(100) NOT NULL
    types JSONB NOT NULL,
    stats JSONB NOT NULL,
    
);
SQL

try {
    $dbh->do($create_table);
    print "Table pokemon created successfully."
} catch {
    my $error = $_;
    die "Caught error: $error";
};
