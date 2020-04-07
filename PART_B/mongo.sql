1. mongoimport --db iitdb --collection restaurents --file restaurants.json

var myCursor = db.bios.find( );

myCursor.forEach(printjson);

2. db.restaurents.find( { borough: "Brooklyn" } )

3. db.restaurents.count({grades: {$elemMatch: {score: {$gt: 70}}}})

4. db.restaurents.find({cuisine: { $ne: "Australian" }, grades: {$elemMatch: {grade: "A"}}}, {name: 1, cuisine: 1, _id: 0})

-- asc = 1
-- desc = -1
5. db.restaurents.find({"grades.0.grade": "A"}, {name: 1, cuisine: 1, borough: 1 , _id: 0}).sort({name: 1, borough: -1})

6. db.restaurents.find({grades: { $gt: { $size: 3 }}})

7. db.restaurents.aggregate([{ $match : { borough: "Bronx"}}, { $group: { _id: "$cuisine", total: { $sum: 1 } } }, { $match: { _id : "Caribbean"}}])

8. db.restaurents.aggregate([{ $group: { _id: { borough: "$borough", cuisine: "$cuisine" }, total: { $sum: 1 } } }, { $match: {"_id.borough": "Manhattan"}}, {$sort: {"total": -1}}, { $limit: 1 }])