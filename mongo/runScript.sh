container=$1
script=$2

docker exec -i $container mongo < $script