uri=$1 # mongodb://user:pass@localhost:27017/holefeeder?authSource=holefeeder
container=$2

docker exec -it $container mongo $uri

use holefeeder

var filterNull = { $or: [ { 'globalId': null }, { $and: [ { 'globalId' : { $type : 2 } }, { 'globalId': { $eq: '' } } ] } ] }
var filter = { 'globalId' : { $type : 2 } }

db.accounts.updateMany( {}, { $rename: { "guid": "globalId" } } );
db.accounts.find( filterNull ).forEach( function (x) { x.globalId = new UUID(); db.accounts.save(x);});
db.accounts.find( filter ).forEach( function (x) { x.globalId = new UUID(x.globalId); db.accounts.save(x);});
db.accounts.find( filterNull ).count();

db.cashflows.updateMany( {}, { $rename: { "guid": "globalId" } } );
db.cashflows.find( filterNull ).forEach( function (x) { x.globalId = new UUID(); db.cashflows.save(x);});
db.cashflows.find( filter ).forEach( function (x) { x.globalId = new UUID(x.globalId); db.cashflows.save(x);});
db.cashflows.find( filterNull ).count();

db.categories.updateMany( {}, { $rename: { "guid": "globalId" } } );
db.categories.find( filterNull ).forEach( function (x) { x.globalId = new UUID(); db.categories.save(x);});
db.categories.find( filter ).forEach( function (x) { x.globalId = new UUID(x.globalId); db.categories.save(x);});
db.categories.find( filterNull ).count();

db.transactions.updateMany( {}, { $rename: { "guid": "globalId" } } );
db.transactions.find( filterNull ).forEach( function (x) { x.globalId = new UUID(); db.transactions.save(x);});
db.transactions.find( filter ).forEach( function (x) { x.globalId = new UUID(x.globalId); db.transactions.save(x);});
db.transactions.find( filterNull ).count();

db.users.drop();