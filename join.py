from glob import glob    
import os
import os.path
import pandas as pd
import sys

# Parse our command-line arguments.
if len(sys.argv) != 4:
    print("Usage: python join.py POPULATION_PATH LATLON_PATH OUT_PATH",
              file=sys.stderr)
    sys.exit(1)
_ignored, population_path, latlon_path, out_path = sys.argv

# Create our output directory.
os.makedirs(out_path, exist_ok=True)

# Generate a list of zip-code prefixes to handle.
population_prefixes = { s.split("/")[-1] for s in glob("{}/*".format(population_path)) }
latlon_prefixes = { s.split("/")[-1] for s in glob("{}/*".format(latlon_path)) }
prefixes = population_prefixes.union(latlon_prefixes)

def load_csv(path, columns):
    """Load a CSV, and index it on the GEOID column (or create it if missing)."""
    if os.path.isfile(path):
        data = pd.read_csv(path)
    else:
        # Create an empty frame.
        data = pd.DataFrame(columns=columns)
    data.set_index("GEOID")
    return data

# Handle each input prefix.
for prefix in prefixes:
    population = load_csv("{}/{}/population.csv".format(population_path, prefix),
                              ["GEOID", "POP10"])
    latlon = load_csv("{}/{}/latlon.csv".format(latlon_path, prefix),
                          ["GEOID", "INTPTLAT", "INTPTLONG"])
    merged = population.merge(latlon).sort_index()
    merged.to_csv("{}/{}.csv".format(out_path, prefix), index=False)
