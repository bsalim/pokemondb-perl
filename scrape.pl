#!/usr/bin/perl
use strict;
use utf8;
use warnings;

use DBI;
use LWP::UserAgent;
use List::Util qw(shuffle);
use Mojo::DOM;
use Mojo::JSON;
use Mojolicious::Lite;
use Mojo::UserAgent;


# Constants
my $BASE_URL = 'https://pokemondb.net';
my $MAX_CONCURRENCY = 5;
my $MAX_POKEMON = 10;

# Database config
my $dbname = 'pokemondb';
my $host = 'localhost';
my $port = '5432';
my $user = 'postgres';
my $password = 'Cunyono*189';

my $dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$host;port=$port", $user, $password, {
    PrintError => 0,
    RaiseError => 1,
    AutoCommit => 1,
}) or die "Error connecting to database: $DBI::errstr";

my @user_agent_list = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/91.0.864.67 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Firefox/89.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Firefox/89.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Safari/537.36",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Mobile/15E148 Safari/604.1",
    "Mozilla/5.0 (iPad; CPU OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Mobile/15E148 Safari/604.1",
    "Mozilla/5.0 (Linux; Android 11; SM-G991U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; Pixel 4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; SM-N986U1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; Redmi Note 9 Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; SM-G998U1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; LM-G900TM) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; M2007J17G) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; SM-A426U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; SM-A515U1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; SM-G781U1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; Xbox; Xbox One) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edge/18.19041",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; Xbox; Xbox One) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; Xbox; Xbox One) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; Xbox; Xbox One) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; Xbox; Xbox One) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; Xbox; Xbox One) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; Xbox; Xbox One) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; Xbox; Xbox One) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; Xbox; Xbox One) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; Xbox; Xbox One) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/91.0.864.67 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Firefox/89.0",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Firefox/89.0",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Firefox/89.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Safari/537.36",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Mobile/15E148 Safari/604.1",
    "Mozilla/5.0 (iPad; CPU OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Mobile/15E148 Safari/604.1",
    "Mozilla/5.0 (Linux; Android 11; SM-G991U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; Pixel 4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; SM-N986U1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; Redmi Note 9 Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; SM-G998U1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; LM-G900TM) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; M2007J17G) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; SM-A426U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; SM-A515U1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; SM-G781U1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; Xbox; Xbox One) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edge/18.19041"
);

package PokemonScraper;

sub new {
    my ($class, %args) = @_;

    my $self = {
        user_agent_list => $args{user_agent_list} || [],
        base_url => $BASE_URL,
        main_url => $BASE_URL . '/pokedex/all',
        urls => [],
        max_pokemon => $args{max_pokemon} || $MAX_POKEMON, 
        max_concurrency => $args{max_concurrency} || $MAX_CONCURRENCY,
        dbh => $args{dbh},  
    };


    bless $self, $class;
    return $self;
}

sub pick_random_user_agent {
    my ($self) = @_;
    my @user_agents = @{$self->{user_agent_list}};
    my $random_agent = $user_agents[rand @user_agents];

    return $random_agent;
}

sub scrape_main_url {
    my ($self) = @_;
    my $ua = Mojo::UserAgent->new;
    my $tx = $ua->get($self->{main_url},
        { 
            'User-Agent' => $self->pick_random_user_agent(),
            'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            'Accept-Language' => 'en-US,en;q=0.5',
            'Connection'      => 'keep-alive',
            'Cache-Control'   => 'max-age=0',
        }
    );
    my $res = $tx->result;

    unless ($res->is_success) {
        die "Failed to get $self->{base_url}: " . $res->message . "\n";
    }

    my $body = $res->body;
    my $dom = Mojo::DOM->new($body);

    $dom->find('a.ent-name')->reverse->each(sub {
        my $href = shift->attr('href');
        push @{$self->{urls}}, $self->{base_url} . $href if defined $href;
    });

    # DEBUGGING
    # foreach my $url (@{$self->{urls}}) {
    #     say "Pokemon URL: " .  $url;
    # }
}

sub start_scraping {
    my ($self) = @_;

    # This scrape_main_urls is to populate the $self.urls to contain the Pokemon details url
    $self->scrape_main_url();
}

sub fetch_pokemon_details {
    my ($self) = @_;
    my @urls = @{$self->{urls}};
    my $ua = Mojo::UserAgent->new;
    my @promises;
    my $tx_count = 0;

    for my $index (0 .. $self->{max_pokemon} - 1) {
        # Ensure we don't exceed the maximum number of concurrent requests
        if ($tx_count >= $self->{max_concurrency}) {
            Mojo::Promise->all(@promises)->wait;
            @promises = ();
            $tx_count = 0;
        }

        my $url = $urls[$index];
        my $promise = Mojo::Promise->new;
        push @promises, $promise;

        $ua->get(
            $url,
            {
                'User-Agent'      => $self->pick_random_user_agent(),
                'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
                'Accept-Language' => 'en-US,en;q=0.5',
                'Connection'      => 'keep-alive',
                'Cache-Control'   => 'max-age=0',
            },
            sub {
                my ($ua, $tx) = @_;

                if (my $res = $tx->result) {
                    my $body = $res->body;
                    $self->process_pokemon_data($body);
                    $promise->resolve($url);
                } else {
                    my ($err, $code) = $tx->error;
                    warn "Failed to make a request $url: $code $err\n";
                    $promise->reject("Failed to $url: $code $err");
                }
            }
        );
        $tx_count++;
    }

    # Wait for any remaining promises to complete
    Mojo::Promise->all(@promises)->then(sub {
        my @urls = @_;
        say "All requests completed successfully for URLs: @urls";
    })->catch(sub {
        my $err = shift;
        warn "One or more requests failed: $err\n";
    })->wait;
}

sub process_pokemon_data {
    my ($self, $content) = @_;
    my $pokemon_name;
    my %pokemon_data;
    my @pokemon_types;

    my $dom = Mojo::DOM->new($content);

    $pokemon_name = $dom->at('h1')->text;
    my $pokedex_dom = $dom->find('table.vitals-table')->[0];
    my $stats_dom = $dom->find('table.vitals-table')->[3];
    my ($species, @pokemon_types) = $self->_parse_pokedex_data($pokedex_dom);
    my $stats_json_data  = $self->_parse_stats_table($stats_dom);

    %pokemon_data = (
        'name' => $pokemon_name,
        'species' => $species,
        'types' => \@pokemon_types,
        'stats' => $stats_json_data
    );
    # DEBUGGING
    # say "Pokemon: $pokemon_name";
    # say "Species: $species";
    # say "Stats: $stats_json_data";
    # say "Types: @pokemon_types";
    
    # foreach my $key (keys %pokemon_data) {
    # say $key;
    # my $value = $pokemon_data{$key};
    # say $value;
    # if (ref $value eq 'ARRAY') {
    #     $value = join(', ', @$value);
    # }
    # say "$key: $value";
    # }
    # say %pokemon_data;
    $self->insert_pokemon_data(\%pokemon_data);
}

sub _parse_pokedex_data {
    my ($self, $dom_obj) = @_;
    my $type_row;
    my $species_row;
    my @pokemon_types;
    my $species;

    # Find the "Type" row
    for my $tr ($dom_obj->find('tr')->each) {
        if ($tr->at('th') && $tr->at('th')->text eq 'Type') {
            $type_row = $tr;
            last;
        }
    }

    # Extract types if the "Type" row is found
    if ($type_row) {
        my $type_td = $type_row->at('td');
        @pokemon_types = $type_td->find('a')->map('text')->each;
        say "Types: " . join(', ', @pokemon_types);
    }

    # Find the "Species" row
    for my $tr ($dom_obj->find('tr')->each) {
        if ($tr->at('th') && $tr->at('th')->text eq 'Species') {
            $species_row = $tr;
            last;
        }
    }

    # Extract species if the "Species" row is found
    if ($species_row) {
        my $species_td = $species_row->at('td');
        $species = $species_td->text if defined $species_td;
        say $species if defined $species;
    }

    return ($species, @pokemon_types);
}

sub insert_pokemon_data {
    my ($self, $pokemon_data_ref) = @_;

    my $dbh = $self->{dbh};
    return unless $dbh;

    my %pokemon_data = %$pokemon_data_ref;

    say 'Start inserting to DB';
    
    my $name = $dbh->quote($pokemon_data{name});
    my $types_json = Mojo::JSON::encode_json($pokemon_data{types});
    my $stats_json = $pokemon_data{stats};
    my $species = $dbh->quote($pokemon_data{species});  # Quote species value

    my $insert_sql = "INSERT INTO pokemon (name, types, stats, species) VALUES ($name, '$types_json', '$stats_json', $species)";
    $dbh->do($insert_sql) or warn "Failed to insert Pokémon $pokemon_data{name}: " . $dbh->errstr;
}

sub _parse_stats_table {
    my ($self, $dom_obj) = @_;
    my %stats;

    $dom_obj->find('table.vitals-table tbody tr')->each(sub {
        my $tr = shift;

        my $th_text = $tr->at('th')->text;
        my $td_text = $tr->at('td.cell-num')->text;

        # Ensure $td_text is defined before assigning to %stats
        $stats{$th_text} = $td_text if defined $td_text;
    });

    # Print each key-value pair in %stats for debugging
    # foreach my $key (keys %stats) {
    #     my $value = $stats{$key}; 
    #     say "$key: $value";  
    # }

    my $json_data = Mojo::JSON::encode_json(\%stats);
    say "Encoded JSON: $json_data";  # Debugging output

    return $json_data;
}

package main;

my $scraper = PokemonScraper->new(
    user_agent_list => \@user_agent_list,
    max_pokemon => $MAX_POKEMON,
    max_concurrency => $MAX_CONCURRENCY,
    dbh => $dbh,
);

$scraper->start_scraping();
$scraper->fetch_pokemon_details();

$dbh->disconnect();