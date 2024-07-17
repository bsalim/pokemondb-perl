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

## How to run
### Initialize DB schema & Change the necessary 
```bash
perl init_db.pl
```

### Start scraping
```bash
perl scrape.pl
```

Happy Exploring!
