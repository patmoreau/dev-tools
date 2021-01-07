uri=$1
container=$2
script=$3

docker exec -i $container mongo $uri < $script