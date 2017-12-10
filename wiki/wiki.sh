export es=localhost:9200
export index=enwiki

echo "Deleting index"
curl -XDELETE $es/$index?pretty

echo "Settings of new index"
curl -XPUT $es/$index?pretty -d @wikipedia.settings.json

echo "Mapping of new index"
curl -XPUT $es/$index/_mapping/page?pretty -d @wikipedia.mapping.simple.json

echo "Loading sample data"
cd chunks

date
for file in *; do
  echo -n "${file}:  "
  took=$(curl -s -XPOST $es/$index/_bulk?pretty --data-binary @$file |
    grep took | cut -d':' -f 2 | cut -d',' -f 1)
  printf '%7s\n' $took
  [ "x$took" = "x" ]
done
date