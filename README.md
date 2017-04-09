# Pachyderm Union Join Test

This is a test case for a proposed Pachyderm feature designed to support
very large N-way joins, where N may equal 5 or 10, and the individual input
repositories may contain hundreds of millions of records. 

The zip code data is from the the file
`Gaz_zcta_national.zip` [available from the US Census][gazetteer2010].  If
you have [`xsv`][xsv] installed, you can regenerate the input data using:

```sh
# Not normally needed.
./generate_data.sh
```

## Creating the input repos

To load the data into the cluster, run:

```sh
./create-repos.sh
```

This will create two input repositories.

## Simulating the designed pipeline locally

To join the data back together, run:

```sh
docker build -t zipjoin .
docker run --rm -v (pwd):/pfs zipjoin
```

This will write the joined data to `out/`.  This should **exactly** match
the contents of `expected`.

## The goal: Do this in the cloud

The goal: Run the `zipjoin` container as a Pachyderm job using the
`population` and `latlon` repositories we created as inputs, and generate
an output repository exactly matching the data in `expected/`.

I've provided a sample `zipjoin.json` pipeline specification.

## Important things to keep in mind

When this is scaled up:

1. The real pileline may have 5 to 10 input repos.
2. Each input repo may contain a 100 million CSV records.
3. The process of merging the data is much more complicated than a simple
   join on the GEOID column—it may be necessary to examine the individual
   records in detail to decide how to join them.

[gazetteer2010]: https://www.census.gov/geo/maps-data/data/gazetteer2010.html
[xsv]: https://github.com/faradayio/xsv
