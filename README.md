# Pokémon Database Project

## Purpose
The purpose of this project is to create a Pokémon database for further exploration and learning.

## Prologue
This project is just my nostalgic dive into Perl, during my programming language exploration in the early 2000s, especially its powerful regex capabilities. While Perl has evolved significantly, this project serves as a playground to explore its latest features and frameworks.

## Project Overview
This project involves scraping Pokémon data from online sources and storing it in a database. It utilizes Perl for backend scripting, database connectivity, and leveraging Mojo libraries for web scraping.


## Features
- **Scraping Pokémon Data**: Utilizes Mojo::UserAgent for web scraping Pokémon details from an external source.
- **Database Integration**: Stores scraped data into a PostgreSQL database using DBI for Perl.
- **Asynchronous Processing**: Implements asynchronous operations with Mojo::Promise for efficient data fetching.
- **JSON Handling**: Mojo::JSON is used for encoding and decoding JSON data, essential for data storage and retrieval.


## Installation
To install dependencies required for the project, use `cpanm` and the `cpanfile` provided:

```bash
cpanm --installdeps .
```

## Configuration Guidelines

### Using Constants and Configuration

When configuring the `PokemonScraper` object, use constants and guidelines to ensure clarity and maintainability in your Perl script:

### Constants

- **`$BASE_URL`**: The base URL of the target website (`pokemondb.net`).
- **`$MAX_CONCURRENCY`**: Maximum number of concurrent requests allowed during scraping operations.
- **`$MAX_POKEMON`**: Maximum number of Pokémon to scrape data for.

### Configuring `PokemonScraper`

When initializing the `PokemonScraper` object, consider the following guidelines:

1. **User Agent List**: Provide an array reference (`\@user_agent_list`) containing user-agent strings to rotate between requests. This helps in mimicking diverse user behavior.

2. **Max Pokemon**: Adjust `$MAX_POKEMON` to specify the maximum number of Pokémon data entries to retrieve during each scraping session.

3. **Max Concurrency**: Set `$MAX_CONCURRENCY` to control the number of concurrent HTTP requests made to the website. Adjust this value based on server capacity and performance considerations.

4. **Database Handler (`dbh`)**: Pass a valid database handle (`$dbh`) to allow the `PokemonScraper` to insert scraped data into the database.

### Example of configuration


```perl
# Constants
my $BASE_URL = 'https://pokemondb.net';
my $MAX_CONCURRENCY = 5;
my $MAX_POKEMON = 100;

# Database configuration (replace with your actual database details)
my $dbname = 'pokemondb';
my $host = 'localhost';
my $port = '5432';
my $user = 'postgres';
my $password = 'XXX';


my @user_agent_list = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/91.0.864.67 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Firefox/89.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
);

# Initialize PokemonScraper object
my $scraper = PokemonScraper->new(
    user_agent_list => \@user_agent_list,
    max_pokemon => $MAX_POKEMON,
    max_concurrency => $MAX_CONCURRENCY,
    dbh => $dbh,
);
```

## How to run
### Initialize DB schema & Change the necessary DB config
```bash
perl init_db.pl
```

### Start scraping
```bash
perl scrape.pl
```

## DISCLAIMER

### Responsible Scraping Practices
- **Respect Site Policies**: Adhere to the terms of service and robots.txt of the target website (pokemondb.net) to ensure ethical scraping practices.
- **Use Delays**: Implement delays between requests to prevent overwhelming the server and to simulate human-like browsing behavior.


## Future releases
- Additional script to push data into RedisJSON structure
- 12-Factor App Compliance
- Dockerfile
- Production deployment config

Happy Coding & Exploring!
