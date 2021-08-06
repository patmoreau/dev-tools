CREATE DATABASE IF NOT EXISTS holefeeder;
GRANT ALL ON holefeeder.* TO 'holefeeder'@'%' WITH GRANT OPTION;

CREATE DATABASE IF NOT EXISTS object_store;
GRANT ALL ON object_store.* TO 'holefeeder'@'%' WITH GRANT OPTION;

GRANT ALL ON *.* TO 'holefeeder'@'%' WITH GRANT OPTION;