FROM tailordev/pandas

WORKDIR /app
ADD join.py .

CMD ["python", "join.py", "/pfs/population", "/pfs/latlon", "/pfs/out"]

# Or combine the two inputs at the /pfs level, if preferred:
#CMD ["python", "join.py", "/pfs/smooshed", "/pfs/smooshed", "/pfs/out"]
