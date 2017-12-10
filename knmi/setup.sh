export es=localhost:9200
export index=knmi

echo "Deleting index"
curl -XDELETE $es/$index?pretty

echo "Settings of new index"
curl -XPUT $es/$index?pretty -d @./scripts/knmi.settings.json

echo "Mapping of new index"
curl -XPUT $es/$index/_mapping/weather?pretty -d @./scripts/knmi.mapping.json

echo "Loading data"

# date
# curl -XPOST $es/$index/_bulk?pretty --data-binary @./data/weather.test.bulk.json > /dev/null
# date

cd data/century
date
for file in *; do
  curl -XPOST $es/$index/_bulk?pretty --data-binary @$file > /dev/null
done
date
