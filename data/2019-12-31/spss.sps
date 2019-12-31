
SET UNICODE=ON.

GET DATA
  /TYPE=TXT
  /FILE="spss.txt"
  /DELCASE=LINE
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=1
  /IMPORTCASE=ALL
  /VARIABLES=
Vrid A100
Vdatesub DATE10
Vstatus A100
Vcid A100
Vcomment A5000
Vlanguage A100
Vreferer A100
Vsessionid A100
Vuseragent A100
Vip A100
Vlong A100
Vlat A100
VGeoCountry A100
VGeoCity A100
VGeoRegion A100
Vpostal A100
var105 A100
var106 A100
var107 A100
var2O1 F5
var2O2 F5
var2O3 F5
var2O4 F5
var2O5 F5
var2O6 F5
var2O7 F5
var2O8 F5
var2O9 F5
var2O10 F5
var2O11 F5
var2O12 F5
var2O13 F5
var2O14 F5
var2O15 F5
var94 F8.0
var96 F8.0
var97 F8.0
var98 F8.0
var99 F8.0
var100 F8.0
var101 F8.0
var102 F8.0
var103 F8.0
var47 F5
var48 F5
var49 F5
var50 F5
var52 F5
var53 F5
var55 F5
var57 F8.0
var59 F8.0
var60 F8.0
var61 F5
var63 F8.0
var64 F8.0
var66 F8.0
var108O319 F5
var108O320 F5
var108O321 F5
var108O322 F5
var70O197 F5
var70O198 F5
var70O207 F5
var70O208 F5
var70O209 F5
var70O210 F5
var70O211 F5
var70O212 F5
var70O213 F5
var70O214 F5
var71O215 F5
var71O216 F5
var71O217 F5
var71O218 F5
var71O219 F5
var71O220 F5
var71O221 F5
var71O222 F5
var71O223 F5
var71O224 F5
var72O225 F5
var72O226 F5
var72O227 F5
var72O228 F5
var72O229 F5
var72O230 F5
var72O231 F5
var72O232 F5
var72O233 F5
var72O234 F5
var73O235 F5
var73O236 F5
var73O237 F5
var73O238 F5
var73O239 F5
var73O240 F5
var73O241 F5
var73O242 F5
var73O243 F5
var73O244 F5
var74O245 F5
var74O246 F5
var74O247 F5
var74O248 F5
var74O249 F5
var74O250 F5
var74O251 F5
var74O252 F5
var74O253 F5
var74O254 F5
var75O255 F5
var75O256 F5
var75O257 F5
var75O258 F5
var75O259 F5
var75O260 F5
var75O261 F5
var75O262 F5
var75O263 F5
var75O264 F5
var76O265 F5
var76O266 F5
var76O267 F5
var76O268 F5
var76O269 F5
var76O270 F5
var76O271 F5
var76O272 F5
var76O273 F5
var76O274 F5
var77O275 F5
var77O276 F5
var77O277 F5
var77O278 F5
var77O279 F5
var77O280 F5
var77O281 F5
var77O282 F5
var77O283 F5
var77O284 F5
var78O285 F5
var78O286 F5
var78O287 F5
var78O288 F5
var78O289 F5
var78O290 F5
var78O291 F5
var78O292 F5
var78O293 F5
var78O294 F5
var80O197 F8.0
var80O198 F8.0
var80O207 F8.0
var80O208 F8.0
var80O209 F8.0
var80O210 F8.0
var80O211 F8.0
var80O212 F8.0
var80O213 F8.0
var81O215 F8.0
var81O216 F8.0
var81O218 F8.0
var81O219 F8.0
var81O220 F8.0
var81O221 F8.0
var81O222 F8.0
var81O223 F8.0
var82O225 F8.0
var82O226 F8.0
var82O227 F8.0
var82O228 F8.0
var82O229 F8.0
var82O230 F8.0
var82O231 F8.0
var82O232 F8.0
var82O233 F8.0
var83O235 F8.0
var83O236 F8.0
var83O237 F8.0
var83O238 F8.0
var83O239 F8.0
var83O240 F8.0
var83O241 F8.0
var83O242 F8.0
var83O243 F8.0
var84O245 F8.0
var84O246 F8.0
var84O247 F8.0
var84O248 F8.0
var84O249 F8.0
var84O250 F8.0
var84O251 F8.0
var84O252 F8.0
var84O253 F8.0
var85O255 F8.0
var85O256 F8.0
var85O257 F8.0
var85O258 F8.0
var85O259 F8.0
var85O260 F8.0
var85O262 F8.0
var85O263 F8.0
var86O265 F8.0
var86O266 F8.0
var86O267 F8.0
var86O269 F8.0
var86O270 F8.0
var86O271 F8.0
var86O272 F8.0
var86O273 F8.0
var87O275 F8.0
var87O276 F8.0
var87O277 F8.0
var87O278 F8.0
var87O279 F8.0
var87O281 F8.0
var87O282 F8.0
var87O283 F8.0
var88O285 F8.0
var88O286 F8.0
var88O287 F8.0
var88O288 F8.0
var88O289 F8.0
var88O290 F8.0
var88O291 F8.0
var88O292 F8.0
var88O293 F8.0
var9 F5
var10 F5
var11 F5
var12 F5
var12O59Othr A255
var13 F5 .

EXECUTE.

VARIABLE LABELS
 Vrid "Response ID"
 Vdatesub "Date Submitted"
 Vstatus "Status"
 Vcid "Contact ID"
 Vcomment "Comments"
 Vlanguage "Language"
 Vreferer "Referer"
 Vsessionid "SessionID"
 Vuseragent "User Agent"
 Vip "IP Address"
 Vlong "Longitude"
 Vlat "Latitude"
 VGeoCountry "Country"
 VGeoCity "City"
 VGeoRegion "State/Region"
 Vpostal "Postal"
 var105 "id"
 var106 "Cortex_ID"
 var107 "pid"
 var2O1 "Trail Sports (running 3+ miles on paved/unpaved trail, day-hiking, backpacking, climbing ice or rock, mountaineering, horseback riding):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply:"
 var2O2 "Bicycling or skateboarding (on paved road or off-road):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply:"
 var2O3 "Camping (RV at campsite, tent campsite, or at a rustic lodge):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply:"
 var2O4 "Picnicking or relaxing:Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply:"
 var2O5 "Water sports (swimming, canoeing, kayaking, rafting, paddle-boarding, sailing, recreating with motorized boat):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply:"
 var2O6 "Snow sports (skiing cross-country/downhill/telemark, snowboarding, snowshoeing):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply:"
 var2O7 "Hunting & shooting (shotgun, rifle, or bow):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply:"
 var2O8 "Fishing (recreational fly and non-fly):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply:"
 var2O9 "Wildlife-watching (viewing, feeding, or photographing animals, bird watching):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply:"
 var2O10 "Team competitive sports (softball/baseball, volleyball, soccer, ultimate frisbee):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply:"
 var2O11 "Off-roading with ATVs, 4x4 trucks:Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply:"
 var2O12 "Individual competitive sports (golf, tennis):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply:"
 var2O13 "Motorcycling (on-road, off-road):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply:"
 var2O14 "Playground activities:Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply:"
 var2O15 "I didn't participate in any of these activities:Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply:"
 var94 "Trail Sports (running 3+ miles on paved/unpaved trail, day-hiking, backpacking, climbing ice or rock, mountaineering, horseback riding)"
 var96 "Bicycling or skateboarding (on paved road or off-road)"
 var97 "Camping (RV at campsite, tent campsite, or at a rustic lodge)"
 var98 "Picnicking or relaxing"
 var99 "Water sports (swimming, canoeing, kayaking, rafting, paddle-boarding, sailing, recreating with motorized boat)"
 var100 "Snow sports (skiing cross-country/downhill/telemark, snowboarding, snowshoeing)"
 var101 "Hunting & shooting (shotgun, rifle, or bow)"
 var102 "Fishing (recreational fly and non-fly)"
 var103 "Wildlife-watching (viewing, feeding, or photographing animals, bird watching)"
 var47 "Trail Sports (running 3+ miles on paved/unpaved trail, day-hiking, backpacking, climbing ice or rock, mountaineering, horseback riding):Did you participate in any of these activities on or along a body of water (e g  river, lake, reservoir, or stream) in Colorado over the twelve months from December 1, 2018 and November 30, 2019? Please only count those days where the selected activity was your primary reason for being on the water  Note:  By “on or along a body of water” we mean any place where water was in view or nearby at some point during your recreational activity "
 var48 "Bicycling or skateboarding (on paved road or off-road):Did you participate in any of these activities on or along a body of water (e g  river, lake, reservoir, or stream) in Colorado over the twelve months from December 1, 2018 and November 30, 2019? Please only count those days where the selected activity was your primary reason for being on the water  Note:  By “on or along a body of water” we mean any place where water was in view or nearby at some point during your recreational activity "
 var49 "Camping (RV at campsite, tent campsite, or at a rustic lodge):Did you participate in any of these activities on or along a body of water (e g  river, lake, reservoir, or stream) in Colorado over the twelve months from December 1, 2018 and November 30, 2019? Please only count those days where the selected activity was your primary reason for being on the water  Note:  By “on or along a body of water” we mean any place where water was in view or nearby at some point during your recreational activity "
 var50 "Picnicking or relaxing:Did you participate in any of these activities on or along a body of water (e g  river, lake, reservoir, or stream) in Colorado over the twelve months from December 1, 2018 and November 30, 2019? Please only count those days where the selected activity was your primary reason for being on the water  Note:  By “on or along a body of water” we mean any place where water was in view or nearby at some point during your recreational activity "
 var52 "Snow sports (skiing cross-country/downhill/telemark, snowboarding, snowshoeing):Did you participate in any of these activities on or along a body of water (e g  river, lake, reservoir, or stream) in Colorado over the twelve months from December 1, 2018 and November 30, 2019? Please only count those days where the selected activity was your primary reason for being on the water  Note:  By “on or along a body of water” we mean any place where water was in view or nearby at some point during your recreational activity "
 var53 "Hunting & shooting (shotgun, rifle, or bow):Did you participate in any of these activities on or along a body of water (e g  river, lake, reservoir, or stream) in Colorado over the twelve months from December 1, 2018 and November 30, 2019? Please only count those days where the selected activity was your primary reason for being on the water  Note:  By “on or along a body of water” we mean any place where water was in view or nearby at some point during your recreational activity "
 var55 "Wildlife-watching (viewing, feeding, or photographing animals, bird watching):Did you participate in any of these activities on or along a body of water (e g  river, lake, reservoir, or stream) in Colorado over the twelve months from December 1, 2018 and November 30, 2019? Please only count those days where the selected activity was your primary reason for being on the water  Note:  By “on or along a body of water” we mean any place where water was in view or nearby at some point during your recreational activity "
 var57 "You participated in trail sports (running 3+ miles, day-hiking, backpacking, climbing ice or rock, mountaineering, horseback riding) [question('value'), id='94'] days  How many were on or along the water?"
 var59 "You participated in bicycling or skateboarding (on paved road or off-road) [question('value'), id='96'] days  How many were on or along the water?"
 var60 "You participated in camping (RV at campsite, tent campsite, or at a rustic lodge) [question('value'), id='97'] days  How many were on or along the water?"
 var61 "You participated in picnicking or relaxing [question('value'), id='98'] days  How many were on or along the water?"
 var63 "You participated in snow sports (skiing cross-country/downhill/telemark, snowboarding, snowshoeing) [question('value'), id='100'] days  How many were on or along the water?"
 var64 "You participated in hunting & shooting (shotgun, rifle, or bow) [question('value'), id='101'] days  How many were on or along the water?"
 var66 "You participated in wildlife-watching (viewing, feeding, or photographing animals, bird watching) [question('value'), id='103'] days  How many were on or along the water?"
 var108O319 "Northeast (South Platte River Basin and Metro Region):The next few questions help us learn more about the river you visited   You can open more detailed regional maps (referencing major cities, roadways, and water bodies) by checking the box beside a region list below to refresh your memory   To hide the detailed regional maps, uncheck the box "
 var108O320 "Northwest (Yampa, White, & Green River Basin North Platte River Basin Colorado River Basin):The next few questions help us learn more about the river you visited   You can open more detailed regional maps (referencing major cities, roadways, and water bodies) by checking the box beside a region list below to refresh your memory   To hide the detailed regional maps, uncheck the box "
 var108O321 "Southeast (Arkansas River Basin):The next few questions help us learn more about the river you visited   You can open more detailed regional maps (referencing major cities, roadways, and water bodies) by checking the box beside a region list below to refresh your memory   To hide the detailed regional maps, uncheck the box "
 var108O322 "Southwest (Dolores, San Miguel, & San Juan River Basin Gunnison River Basin Rio Grande River Basin):The next few questions help us learn more about the river you visited   You can open more detailed regional maps (referencing major cities, roadways, and water bodies) by checking the box beside a region list below to refresh your memory   To hide the detailed regional maps, uncheck the box "
 var70O197 "Arkansas River Basin:TRAIL SPORTS"
 var70O198 "Colorado River Basin:TRAIL SPORTS"
 var70O207 "Gunnison River Basin:TRAIL SPORTS"
 var70O208 "Metro Area:TRAIL SPORTS"
 var70O209 "North Platte River Basin:TRAIL SPORTS"
 var70O210 "Rio Grande River Basin:TRAIL SPORTS"
 var70O211 "South Platte River Basin (excluding Metro Area):TRAIL SPORTS"
 var70O212 "Southwest River Basin:TRAIL SPORTS"
 var70O213 "Yampa-White River Basin:TRAIL SPORTS"
 var70O214 "I did not engage in trail sports on or along the water during this time period:TRAIL SPORTS"
 var71O215 "Arkansas River Basin:BICYCLING OR SKATEBOARDING"
 var71O216 "Colorado River Basin:BICYCLING OR SKATEBOARDING"
 var71O217 "Gunnison River Basin:BICYCLING OR SKATEBOARDING"
 var71O218 "Metro Area:BICYCLING OR SKATEBOARDING"
 var71O219 "North Platte River Basin:BICYCLING OR SKATEBOARDING"
 var71O220 "Rio Grande River Basin:BICYCLING OR SKATEBOARDING"
 var71O221 "South Platte River Basin (excluding Metro Area):BICYCLING OR SKATEBOARDING"
 var71O222 "Southwest River Basin:BICYCLING OR SKATEBOARDING"
 var71O223 "Yampa-White River Basin:BICYCLING OR SKATEBOARDING"
 var71O224 "I did not engage in bicycling or skateboarding on or along the water during this time period:BICYCLING OR SKATEBOARDING"
 var72O225 "Arkansas River Basin:CAMPING"
 var72O226 "Colorado River Basin:CAMPING"
 var72O227 "Gunnison River Basin:CAMPING"
 var72O228 "Metro Area:CAMPING"
 var72O229 "North Platte River Basin:CAMPING"
 var72O230 "Rio Grande River Basin:CAMPING"
 var72O231 "South Platte River Basin (excluding Metro Area):CAMPING"
 var72O232 "Southwest River Basin:CAMPING"
 var72O233 "Yampa-White River Basin:CAMPING"
 var72O234 "I did not engage in camping on or along the water during this time period:CAMPING"
 var73O235 "Arkansas River Basin:PICNICKING OR RELAXING"
 var73O236 "Colorado River Basin:PICNICKING OR RELAXING"
 var73O237 "Gunnison River Basin:PICNICKING OR RELAXING"
 var73O238 "Metro Area:PICNICKING OR RELAXING"
 var73O239 "North Platte River Basin:PICNICKING OR RELAXING"
 var73O240 "Rio Grande River Basin:PICNICKING OR RELAXING"
 var73O241 "South Platte River Basin (excluding Metro Area):PICNICKING OR RELAXING"
 var73O242 "Southwest River Basin:PICNICKING OR RELAXING"
 var73O243 "Yampa-White River Basin:PICNICKING OR RELAXING"
 var73O244 "I did not engage in picnicking or relaxing on or along the water during this time period:PICNICKING OR RELAXING"
 var74O245 "Arkansas River Basin:WATER SPORTS"
 var74O246 "Colorado River Basin:WATER SPORTS"
 var74O247 "Gunnison River Basin:WATER SPORTS"
 var74O248 "Metro Area:WATER SPORTS"
 var74O249 "North Platte River Basin:WATER SPORTS"
 var74O250 "Rio Grande River Basin:WATER SPORTS"
 var74O251 "South Platte River Basin (excluding Metro Area):WATER SPORTS"
 var74O252 "Southwest River Basin:WATER SPORTS"
 var74O253 "Yampa-White River Basin:WATER SPORTS"
 var74O254 "I did not engage in water sports on or along the water during this time period:WATER SPORTS"
 var75O255 "Arkansas River Basin:SNOW SPORTS"
 var75O256 "Colorado River Basin:SNOW SPORTS"
 var75O257 "Gunnison River Basin:SNOW SPORTS"
 var75O258 "Metro Area:SNOW SPORTS"
 var75O259 "North Platte River Basin:SNOW SPORTS"
 var75O260 "Rio Grande River Basin:SNOW SPORTS"
 var75O261 "South Platte River Basin (excluding Metro Area):SNOW SPORTS"
 var75O262 "Southwest River Basin:SNOW SPORTS"
 var75O263 "Yampa-White River Basin:SNOW SPORTS"
 var75O264 "I did not engage in snow sports on or along the water during this time period:SNOW SPORTS"
 var76O265 "Arkansas River Basin:HUNTING AND SHOOTING"
 var76O266 "Colorado River Basin:HUNTING AND SHOOTING"
 var76O267 "Gunnison River Basin:HUNTING AND SHOOTING"
 var76O268 "Metro Area:HUNTING AND SHOOTING"
 var76O269 "North Platte River Basin:HUNTING AND SHOOTING"
 var76O270 "Rio Grande River Basin:HUNTING AND SHOOTING"
 var76O271 "South Platte River Basin (excluding Metro Area):HUNTING AND SHOOTING"
 var76O272 "Southwest River Basin:HUNTING AND SHOOTING"
 var76O273 "Yampa-White River Basin:HUNTING AND SHOOTING"
 var76O274 "I did not engage in hunting and shooting on or along the water during this time period:HUNTING AND SHOOTING"
 var77O275 "Arkansas River Basin:FISHING"
 var77O276 "Colorado River Basin:FISHING"
 var77O277 "Gunnison River Basin:FISHING"
 var77O278 "Metro Area:FISHING"
 var77O279 "North Platte River Basin:FISHING"
 var77O280 "Rio Grande River Basin:FISHING"
 var77O281 "South Platte River Basin (excluding Metro Area):FISHING"
 var77O282 "Southwest River Basin:FISHING"
 var77O283 "Yampa-White River Basin:FISHING"
 var77O284 "I did not engage in fishing on or along the water during this time period:FISHING"
 var78O285 "Arkansas River Basin:WILDLIFE-WATCHING"
 var78O286 "Colorado River Basin:WILDLIFE-WATCHING"
 var78O287 "Gunnison River Basin:WILDLIFE-WATCHING"
 var78O288 "Metro Area:WILDLIFE-WATCHING"
 var78O289 "North Platte River Basin:WILDLIFE-WATCHING"
 var78O290 "Rio Grande River Basin:WILDLIFE-WATCHING"
 var78O291 "South Platte River Basin (excluding Metro Area):WILDLIFE-WATCHING"
 var78O292 "Southwest River Basin:WILDLIFE-WATCHING"
 var78O293 "Yampa-White River Basin:WILDLIFE-WATCHING"
 var78O294 "I did not engage in wildlife-watching on or along the water during this time period:WILDLIFE-WATCHING"
 var80O197 "Arkansas River Basin:Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outing  If none of your outings were primarily for TRAIL SPORTS, please enter 0 "
 var80O198 "Colorado River Basin:Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outing  If none of your outings were primarily for TRAIL SPORTS, please enter 0 "
 var80O207 "Gunnison River Basin:Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outing  If none of your outings were primarily for TRAIL SPORTS, please enter 0 "
 var80O208 "Metro Area:Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outing  If none of your outings were primarily for TRAIL SPORTS, please enter 0 "
 var80O209 "North Platte River Basin:Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outing  If none of your outings were primarily for TRAIL SPORTS, please enter 0 "
 var80O210 "Rio Grande River Basin:Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outing  If none of your outings were primarily for TRAIL SPORTS, please enter 0 "
 var80O211 "South Platte River Basin (excluding Metro Area):Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outing  If none of your outings were primarily for TRAIL SPORTS, please enter 0 "
 var80O212 "Southwest River Basin:Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outing  If none of your outings were primarily for TRAIL SPORTS, please enter 0 "
 var80O213 "Yampa-White River Basin:Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outing  If none of your outings were primarily for TRAIL SPORTS, please enter 0 "
 var81O215 "Arkansas River Basin:Of the [question('value'), id='59'] days you participated in BICYCLING OR SKATEBOARDING activities on or along the water, how many were spent in each basin? Please count only those days when BICYCLING OR SKATEBOARDING was the primary reason of your outing  If none of your outings were primarily for BICYCLING OR SKATEBOARDING, please enter 0 "
 var81O216 "Colorado River Basin:Of the [question('value'), id='59'] days you participated in BICYCLING OR SKATEBOARDING activities on or along the water, how many were spent in each basin? Please count only those days when BICYCLING OR SKATEBOARDING was the primary reason of your outing  If none of your outings were primarily for BICYCLING OR SKATEBOARDING, please enter 0 "
 var81O218 "Metro Area:Of the [question('value'), id='59'] days you participated in BICYCLING OR SKATEBOARDING activities on or along the water, how many were spent in each basin? Please count only those days when BICYCLING OR SKATEBOARDING was the primary reason of your outing  If none of your outings were primarily for BICYCLING OR SKATEBOARDING, please enter 0 "
 var81O219 "North Platte River Basin:Of the [question('value'), id='59'] days you participated in BICYCLING OR SKATEBOARDING activities on or along the water, how many were spent in each basin? Please count only those days when BICYCLING OR SKATEBOARDING was the primary reason of your outing  If none of your outings were primarily for BICYCLING OR SKATEBOARDING, please enter 0 "
 var81O220 "Rio Grande River Basin:Of the [question('value'), id='59'] days you participated in BICYCLING OR SKATEBOARDING activities on or along the water, how many were spent in each basin? Please count only those days when BICYCLING OR SKATEBOARDING was the primary reason of your outing  If none of your outings were primarily for BICYCLING OR SKATEBOARDING, please enter 0 "
 var81O221 "South Platte River Basin (excluding Metro Area):Of the [question('value'), id='59'] days you participated in BICYCLING OR SKATEBOARDING activities on or along the water, how many were spent in each basin? Please count only those days when BICYCLING OR SKATEBOARDING was the primary reason of your outing  If none of your outings were primarily for BICYCLING OR SKATEBOARDING, please enter 0 "
 var81O222 "Southwest River Basin:Of the [question('value'), id='59'] days you participated in BICYCLING OR SKATEBOARDING activities on or along the water, how many were spent in each basin? Please count only those days when BICYCLING OR SKATEBOARDING was the primary reason of your outing  If none of your outings were primarily for BICYCLING OR SKATEBOARDING, please enter 0 "
 var81O223 "Yampa-White River Basin:Of the [question('value'), id='59'] days you participated in BICYCLING OR SKATEBOARDING activities on or along the water, how many were spent in each basin? Please count only those days when BICYCLING OR SKATEBOARDING was the primary reason of your outing  If none of your outings were primarily for BICYCLING OR SKATEBOARDING, please enter 0 "
 var82O225 "Arkansas River Basin:Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If none of your outings were primarily for CAMPING, please enter 0 "
 var82O226 "Colorado River Basin:Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If none of your outings were primarily for CAMPING, please enter 0 "
 var82O227 "Gunnison River Basin:Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If none of your outings were primarily for CAMPING, please enter 0 "
 var82O228 "Metro Area:Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If none of your outings were primarily for CAMPING, please enter 0 "
 var82O229 "North Platte River Basin:Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If none of your outings were primarily for CAMPING, please enter 0 "
 var82O230 "Rio Grande River Basin:Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If none of your outings were primarily for CAMPING, please enter 0 "
 var82O231 "South Platte River Basin (excluding Metro Area):Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If none of your outings were primarily for CAMPING, please enter 0 "
 var82O232 "Southwest River Basin:Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If none of your outings were primarily for CAMPING, please enter 0 "
 var82O233 "Yampa-White River Basin:Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If none of your outings were primarily for CAMPING, please enter 0 "
 var83O235 "Arkansas River Basin:Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary reason of your outing  If none of your outings were primarily for PICNICKING OR RELAXING, please enter 0 "
 var83O236 "Colorado River Basin:Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary reason of your outing  If none of your outings were primarily for PICNICKING OR RELAXING, please enter 0 "
 var83O237 "Gunnison River Basin:Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary reason of your outing  If none of your outings were primarily for PICNICKING OR RELAXING, please enter 0 "
 var83O238 "Metro Area:Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary reason of your outing  If none of your outings were primarily for PICNICKING OR RELAXING, please enter 0 "
 var83O239 "North Platte River Basin:Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary reason of your outing  If none of your outings were primarily for PICNICKING OR RELAXING, please enter 0 "
 var83O240 "Rio Grande River Basin:Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary reason of your outing  If none of your outings were primarily for PICNICKING OR RELAXING, please enter 0 "
 var83O241 "South Platte River Basin (excluding Metro Area):Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary reason of your outing  If none of your outings were primarily for PICNICKING OR RELAXING, please enter 0 "
 var83O242 "Southwest River Basin:Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary reason of your outing  If none of your outings were primarily for PICNICKING OR RELAXING, please enter 0 "
 var83O243 "Yampa-White River Basin:Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary reason of your outing  If none of your outings were primarily for PICNICKING OR RELAXING, please enter 0 "
 var84O245 "Arkansas River Basin:Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outing  If none of your outings were primarily for WATER SPORTS, please enter 0 "
 var84O246 "Colorado River Basin:Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outing  If none of your outings were primarily for WATER SPORTS, please enter 0 "
 var84O247 "Gunnison River Basin:Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outing  If none of your outings were primarily for WATER SPORTS, please enter 0 "
 var84O248 "Metro Area:Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outing  If none of your outings were primarily for WATER SPORTS, please enter 0 "
 var84O249 "North Platte River Basin:Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outing  If none of your outings were primarily for WATER SPORTS, please enter 0 "
 var84O250 "Rio Grande River Basin:Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outing  If none of your outings were primarily for WATER SPORTS, please enter 0 "
 var84O251 "South Platte River Basin (excluding Metro Area):Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outing  If none of your outings were primarily for WATER SPORTS, please enter 0 "
 var84O252 "Southwest River Basin:Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outing  If none of your outings were primarily for WATER SPORTS, please enter 0 "
 var84O253 "Yampa-White River Basin:Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outing  If none of your outings were primarily for WATER SPORTS, please enter 0 "
 var85O255 "Arkansas River Basin:Of the [question('value'), id='63'] days you participated in SNOW SPORT activities on or along the water, how many were spent in each basin? Please count only those days when SNOW SPORTS were the primary reason of your outing  If none of your outings were primarily for SNOW SPORTS, please enter 0 "
 var85O256 "Colorado River Basin:Of the [question('value'), id='63'] days you participated in SNOW SPORT activities on or along the water, how many were spent in each basin? Please count only those days when SNOW SPORTS were the primary reason of your outing  If none of your outings were primarily for SNOW SPORTS, please enter 0 "
 var85O257 "Gunnison River Basin:Of the [question('value'), id='63'] days you participated in SNOW SPORT activities on or along the water, how many were spent in each basin? Please count only those days when SNOW SPORTS were the primary reason of your outing  If none of your outings were primarily for SNOW SPORTS, please enter 0 "
 var85O258 "Metro Area:Of the [question('value'), id='63'] days you participated in SNOW SPORT activities on or along the water, how many were spent in each basin? Please count only those days when SNOW SPORTS were the primary reason of your outing  If none of your outings were primarily for SNOW SPORTS, please enter 0 "
 var85O259 "North Platte River Basin:Of the [question('value'), id='63'] days you participated in SNOW SPORT activities on or along the water, how many were spent in each basin? Please count only those days when SNOW SPORTS were the primary reason of your outing  If none of your outings were primarily for SNOW SPORTS, please enter 0 "
 var85O260 "Rio Grande River Basin:Of the [question('value'), id='63'] days you participated in SNOW SPORT activities on or along the water, how many were spent in each basin? Please count only those days when SNOW SPORTS were the primary reason of your outing  If none of your outings were primarily for SNOW SPORTS, please enter 0 "
 var85O262 "Southwest River Basin:Of the [question('value'), id='63'] days you participated in SNOW SPORT activities on or along the water, how many were spent in each basin? Please count only those days when SNOW SPORTS were the primary reason of your outing  If none of your outings were primarily for SNOW SPORTS, please enter 0 "
 var85O263 "Yampa-White River Basin:Of the [question('value'), id='63'] days you participated in SNOW SPORT activities on or along the water, how many were spent in each basin? Please count only those days when SNOW SPORTS were the primary reason of your outing  If none of your outings were primarily for SNOW SPORTS, please enter 0 "
 var86O265 "Arkansas River Basin:Of the [question('value'), id='64'] days you participated in HUNTING & SHOOTING activities on or along the water, how many were spent in each basin? Please count only those days when HUNTING & SHOOTING was the primary reason of your outing  If none of your outings were primarily for HUNTING AND & SHOOTING, please enter 0 "
 var86O266 "Colorado River Basin:Of the [question('value'), id='64'] days you participated in HUNTING & SHOOTING activities on or along the water, how many were spent in each basin? Please count only those days when HUNTING & SHOOTING was the primary reason of your outing  If none of your outings were primarily for HUNTING AND & SHOOTING, please enter 0 "
 var86O267 "Gunnison River Basin:Of the [question('value'), id='64'] days you participated in HUNTING & SHOOTING activities on or along the water, how many were spent in each basin? Please count only those days when HUNTING & SHOOTING was the primary reason of your outing  If none of your outings were primarily for HUNTING AND & SHOOTING, please enter 0 "
 var86O269 "North Platte River Basin:Of the [question('value'), id='64'] days you participated in HUNTING & SHOOTING activities on or along the water, how many were spent in each basin? Please count only those days when HUNTING & SHOOTING was the primary reason of your outing  If none of your outings were primarily for HUNTING AND & SHOOTING, please enter 0 "
 var86O270 "Rio Grande River Basin:Of the [question('value'), id='64'] days you participated in HUNTING & SHOOTING activities on or along the water, how many were spent in each basin? Please count only those days when HUNTING & SHOOTING was the primary reason of your outing  If none of your outings were primarily for HUNTING AND & SHOOTING, please enter 0 "
 var86O271 "South Platte River Basin (excluding Metro Area):Of the [question('value'), id='64'] days you participated in HUNTING & SHOOTING activities on or along the water, how many were spent in each basin? Please count only those days when HUNTING & SHOOTING was the primary reason of your outing  If none of your outings were primarily for HUNTING AND & SHOOTING, please enter 0 "
 var86O272 "Southwest River Basin:Of the [question('value'), id='64'] days you participated in HUNTING & SHOOTING activities on or along the water, how many were spent in each basin? Please count only those days when HUNTING & SHOOTING was the primary reason of your outing  If none of your outings were primarily for HUNTING AND & SHOOTING, please enter 0 "
 var86O273 "Yampa-White River Basin:Of the [question('value'), id='64'] days you participated in HUNTING & SHOOTING activities on or along the water, how many were spent in each basin? Please count only those days when HUNTING & SHOOTING was the primary reason of your outing  If none of your outings were primarily for HUNTING AND & SHOOTING, please enter 0 "
 var87O275 "Arkansas River Basin:Of the [question('value'), id='102'] days you participated in FISHING activities on or along the water, how many were spent in each basin? Please count only those days when FISHING was the primary reason of your outing  If none of your outings were primarily for FISHING, please enter 0 "
 var87O276 "Colorado River Basin:Of the [question('value'), id='102'] days you participated in FISHING activities on or along the water, how many were spent in each basin? Please count only those days when FISHING was the primary reason of your outing  If none of your outings were primarily for FISHING, please enter 0 "
 var87O277 "Gunnison River Basin:Of the [question('value'), id='102'] days you participated in FISHING activities on or along the water, how many were spent in each basin? Please count only those days when FISHING was the primary reason of your outing  If none of your outings were primarily for FISHING, please enter 0 "
 var87O278 "Metro Area:Of the [question('value'), id='102'] days you participated in FISHING activities on or along the water, how many were spent in each basin? Please count only those days when FISHING was the primary reason of your outing  If none of your outings were primarily for FISHING, please enter 0 "
 var87O279 "North Platte River Basin:Of the [question('value'), id='102'] days you participated in FISHING activities on or along the water, how many were spent in each basin? Please count only those days when FISHING was the primary reason of your outing  If none of your outings were primarily for FISHING, please enter 0 "
 var87O281 "South Platte River Basin (excluding Metro Area):Of the [question('value'), id='102'] days you participated in FISHING activities on or along the water, how many were spent in each basin? Please count only those days when FISHING was the primary reason of your outing  If none of your outings were primarily for FISHING, please enter 0 "
 var87O282 "Southwest River Basin:Of the [question('value'), id='102'] days you participated in FISHING activities on or along the water, how many were spent in each basin? Please count only those days when FISHING was the primary reason of your outing  If none of your outings were primarily for FISHING, please enter 0 "
 var87O283 "Yampa-White River Basin:Of the [question('value'), id='102'] days you participated in FISHING activities on or along the water, how many were spent in each basin? Please count only those days when FISHING was the primary reason of your outing  If none of your outings were primarily for FISHING, please enter 0 "
 var88O285 "Arkansas River Basin:Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was the primary reason of your outing  If none of your outings were primarily for WILDLIFE WATCHING, please enter 0 "
 var88O286 "Colorado River Basin:Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was the primary reason of your outing  If none of your outings were primarily for WILDLIFE WATCHING, please enter 0 "
 var88O287 "Gunnison River Basin:Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was the primary reason of your outing  If none of your outings were primarily for WILDLIFE WATCHING, please enter 0 "
 var88O288 "Metro Area:Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was the primary reason of your outing  If none of your outings were primarily for WILDLIFE WATCHING, please enter 0 "
 var88O289 "North Platte River Basin:Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was the primary reason of your outing  If none of your outings were primarily for WILDLIFE WATCHING, please enter 0 "
 var88O290 "Rio Grande River Basin:Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was the primary reason of your outing  If none of your outings were primarily for WILDLIFE WATCHING, please enter 0 "
 var88O291 "South Platte River Basin (excluding Metro Area):Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was the primary reason of your outing  If none of your outings were primarily for WILDLIFE WATCHING, please enter 0 "
 var88O292 "Southwest River Basin:Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was the primary reason of your outing  If none of your outings were primarily for WILDLIFE WATCHING, please enter 0 "
 var88O293 "Yampa-White River Basin:Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was the primary reason of your outing  If none of your outings were primarily for WILDLIFE WATCHING, please enter 0 "
 var9 "What is your age?"
 var10 "What is your gender?"
 var11 "What is your household income?"
 var12 "Please select the choice that best describes your race?"
 var12O59Othr "Other:Please select the choice that best describes your race?"
 var13 "Are you of Hispanic, Latino, or Spanish origin?" .

VALUE LABELS
 var2O1
 0 'Unchecked' 1 'Checked' /
 var2O2
 0 'Unchecked' 1 'Checked' /
 var2O3
 0 'Unchecked' 1 'Checked' /
 var2O4
 0 'Unchecked' 1 'Checked' /
 var2O5
 0 'Unchecked' 1 'Checked' /
 var2O6
 0 'Unchecked' 1 'Checked' /
 var2O7
 0 'Unchecked' 1 'Checked' /
 var2O8
 0 'Unchecked' 1 'Checked' /
 var2O9
 0 'Unchecked' 1 'Checked' /
 var2O10
 0 'Unchecked' 1 'Checked' /
 var2O11
 0 'Unchecked' 1 'Checked' /
 var2O12
 0 'Unchecked' 1 'Checked' /
 var2O13
 0 'Unchecked' 1 'Checked' /
 var2O14
 0 'Unchecked' 1 'Checked' /
 var2O15
 0 'Unchecked' 1 'Checked' /
 var47
 10140 'Yes' 10141 'No' 10142 'Not Sure' /
 var48
 10140 'Yes' 10141 'No' 10142 'Not Sure' /
 var49
 10140 'Yes' 10141 'No' 10142 'Not Sure' /
 var50
 10140 'Yes' 10141 'No' 10142 'Not Sure' /
 var52
 10140 'Yes' 10141 'No' 10142 'Not Sure' /
 var53
 10140 'Yes' 10141 'No' 10142 'Not Sure' /
 var55
 10140 'Yes' 10141 'No' 10142 'Not Sure' /
 var108O319
 0 'Unchecked' 1 'Checked' /
 var108O320
 0 'Unchecked' 1 'Checked' /
 var108O321
 0 'Unchecked' 1 'Checked' /
 var108O322
 0 'Unchecked' 1 'Checked' /
 var70O197
 0 'Unchecked' 1 'Checked' /
 var70O198
 0 'Unchecked' 1 'Checked' /
 var70O207
 0 'Unchecked' 1 'Checked' /
 var70O208
 0 'Unchecked' 1 'Checked' /
 var70O209
 0 'Unchecked' 1 'Checked' /
 var70O210
 0 'Unchecked' 1 'Checked' /
 var70O211
 0 'Unchecked' 1 'Checked' /
 var70O212
 0 'Unchecked' 1 'Checked' /
 var70O213
 0 'Unchecked' 1 'Checked' /
 var70O214
 0 'Unchecked' 1 'Checked' /
 var71O215
 0 'Unchecked' 1 'Checked' /
 var71O216
 0 'Unchecked' 1 'Checked' /
 var71O217
 0 'Unchecked' 1 'Checked' /
 var71O218
 0 'Unchecked' 1 'Checked' /
 var71O219
 0 'Unchecked' 1 'Checked' /
 var71O220
 0 'Unchecked' 1 'Checked' /
 var71O221
 0 'Unchecked' 1 'Checked' /
 var71O222
 0 'Unchecked' 1 'Checked' /
 var71O223
 0 'Unchecked' 1 'Checked' /
 var71O224
 0 'Unchecked' 1 'Checked' /
 var72O225
 0 'Unchecked' 1 'Checked' /
 var72O226
 0 'Unchecked' 1 'Checked' /
 var72O227
 0 'Unchecked' 1 'Checked' /
 var72O228
 0 'Unchecked' 1 'Checked' /
 var72O229
 0 'Unchecked' 1 'Checked' /
 var72O230
 0 'Unchecked' 1 'Checked' /
 var72O231
 0 'Unchecked' 1 'Checked' /
 var72O232
 0 'Unchecked' 1 'Checked' /
 var72O233
 0 'Unchecked' 1 'Checked' /
 var72O234
 0 'Unchecked' 1 'Checked' /
 var73O235
 0 'Unchecked' 1 'Checked' /
 var73O236
 0 'Unchecked' 1 'Checked' /
 var73O237
 0 'Unchecked' 1 'Checked' /
 var73O238
 0 'Unchecked' 1 'Checked' /
 var73O239
 0 'Unchecked' 1 'Checked' /
 var73O240
 0 'Unchecked' 1 'Checked' /
 var73O241
 0 'Unchecked' 1 'Checked' /
 var73O242
 0 'Unchecked' 1 'Checked' /
 var73O243
 0 'Unchecked' 1 'Checked' /
 var73O244
 0 'Unchecked' 1 'Checked' /
 var74O245
 0 'Unchecked' 1 'Checked' /
 var74O246
 0 'Unchecked' 1 'Checked' /
 var74O247
 0 'Unchecked' 1 'Checked' /
 var74O248
 0 'Unchecked' 1 'Checked' /
 var74O249
 0 'Unchecked' 1 'Checked' /
 var74O250
 0 'Unchecked' 1 'Checked' /
 var74O251
 0 'Unchecked' 1 'Checked' /
 var74O252
 0 'Unchecked' 1 'Checked' /
 var74O253
 0 'Unchecked' 1 'Checked' /
 var74O254
 0 'Unchecked' 1 'Checked' /
 var75O255
 0 'Unchecked' 1 'Checked' /
 var75O256
 0 'Unchecked' 1 'Checked' /
 var75O257
 0 'Unchecked' 1 'Checked' /
 var75O258
 0 'Unchecked' 1 'Checked' /
 var75O259
 0 'Unchecked' 1 'Checked' /
 var75O260
 0 'Unchecked' 1 'Checked' /
 var75O261
 0 'Unchecked' 1 'Checked' /
 var75O262
 0 'Unchecked' 1 'Checked' /
 var75O263
 0 'Unchecked' 1 'Checked' /
 var75O264
 0 'Unchecked' 1 'Checked' /
 var76O265
 0 'Unchecked' 1 'Checked' /
 var76O266
 0 'Unchecked' 1 'Checked' /
 var76O267
 0 'Unchecked' 1 'Checked' /
 var76O268
 0 'Unchecked' 1 'Checked' /
 var76O269
 0 'Unchecked' 1 'Checked' /
 var76O270
 0 'Unchecked' 1 'Checked' /
 var76O271
 0 'Unchecked' 1 'Checked' /
 var76O272
 0 'Unchecked' 1 'Checked' /
 var76O273
 0 'Unchecked' 1 'Checked' /
 var76O274
 0 'Unchecked' 1 'Checked' /
 var77O275
 0 'Unchecked' 1 'Checked' /
 var77O276
 0 'Unchecked' 1 'Checked' /
 var77O277
 0 'Unchecked' 1 'Checked' /
 var77O278
 0 'Unchecked' 1 'Checked' /
 var77O279
 0 'Unchecked' 1 'Checked' /
 var77O280
 0 'Unchecked' 1 'Checked' /
 var77O281
 0 'Unchecked' 1 'Checked' /
 var77O282
 0 'Unchecked' 1 'Checked' /
 var77O283
 0 'Unchecked' 1 'Checked' /
 var77O284
 0 'Unchecked' 1 'Checked' /
 var78O285
 0 'Unchecked' 1 'Checked' /
 var78O286
 0 'Unchecked' 1 'Checked' /
 var78O287
 0 'Unchecked' 1 'Checked' /
 var78O288
 0 'Unchecked' 1 'Checked' /
 var78O289
 0 'Unchecked' 1 'Checked' /
 var78O290
 0 'Unchecked' 1 'Checked' /
 var78O291
 0 'Unchecked' 1 'Checked' /
 var78O292
 0 'Unchecked' 1 'Checked' /
 var78O293
 0 'Unchecked' 1 'Checked' /
 var78O294
 0 'Unchecked' 1 'Checked' /
 var9
 10037 '18 to 24' 10038 '25 to 34' 10039 '35 to 44' 10040 '45 to 54' 10041 '55 to 64' 10042 '65 to 74' 10043 '75 or older' /
 var10
 10044 'Male' 10045 'Female' /
 var11
 10046 'Less than $25,000' 10047 '$25,000 to $34,999' 10048 '$35,000 to $49,999' 10049 '$50,000 to $74,999' 10050 '$75,000 to $99,999' 10051 '$100,000 to $124,999' 10052 '$125,000 to $149,999' 10053 '$150,000 or more' /
 var12
 10054 'Asian' 10055 'Native Hawaiian or Other Pacific Islander' 10056 'Black/African-American' 10057 'White' 10058 'American Indian/Alaska Native' 10059 'Other' /
 var13
 10061 'Yes' 10062 'No'  .

VARIABLE LEVEL
 Vrid (SCALE)/
 Vdatesub (SCALE)/
 Vstatus (SCALE)/
 Vcid (SCALE)/
 Vcomment (SCALE)/
 Vlanguage (SCALE)/
 Vreferer (SCALE)/
 Vsessionid (SCALE)/
 Vuseragent (SCALE)/
 Vip (SCALE)/
 Vlong (SCALE)/
 Vlat (SCALE)/
 VGeoCountry (SCALE)/
 VGeoCity (SCALE)/
 VGeoRegion (SCALE)/
 Vpostal (SCALE)/
 var105 (SCALE)/
 var106 (SCALE)/
 var107 (SCALE)/
 var2O1 (NOMINAL)/
 var2O2 (NOMINAL)/
 var2O3 (NOMINAL)/
 var2O4 (NOMINAL)/
 var2O5 (NOMINAL)/
 var2O6 (NOMINAL)/
 var2O7 (NOMINAL)/
 var2O8 (NOMINAL)/
 var2O9 (NOMINAL)/
 var2O10 (NOMINAL)/
 var2O11 (NOMINAL)/
 var2O12 (NOMINAL)/
 var2O13 (NOMINAL)/
 var2O14 (NOMINAL)/
 var2O15 (NOMINAL)/
 var94 (SCALE)/
 var96 (SCALE)/
 var97 (SCALE)/
 var98 (SCALE)/
 var99 (SCALE)/
 var100 (SCALE)/
 var101 (SCALE)/
 var102 (SCALE)/
 var103 (SCALE)/
 var47 (NOMINAL)/
 var48 (NOMINAL)/
 var49 (NOMINAL)/
 var50 (NOMINAL)/
 var52 (NOMINAL)/
 var53 (NOMINAL)/
 var55 (NOMINAL)/
 var57 (SCALE)/
 var59 (SCALE)/
 var60 (SCALE)/
 var61 (SCALE)/
 var63 (SCALE)/
 var64 (SCALE)/
 var66 (SCALE)/
 var108O319 (NOMINAL)/
 var108O320 (NOMINAL)/
 var108O321 (NOMINAL)/
 var108O322 (NOMINAL)/
 var70O197 (NOMINAL)/
 var70O198 (NOMINAL)/
 var70O207 (NOMINAL)/
 var70O208 (NOMINAL)/
 var70O209 (NOMINAL)/
 var70O210 (NOMINAL)/
 var70O211 (NOMINAL)/
 var70O212 (NOMINAL)/
 var70O213 (NOMINAL)/
 var70O214 (NOMINAL)/
 var71O215 (NOMINAL)/
 var71O216 (NOMINAL)/
 var71O217 (NOMINAL)/
 var71O218 (NOMINAL)/
 var71O219 (NOMINAL)/
 var71O220 (NOMINAL)/
 var71O221 (NOMINAL)/
 var71O222 (NOMINAL)/
 var71O223 (NOMINAL)/
 var71O224 (NOMINAL)/
 var72O225 (NOMINAL)/
 var72O226 (NOMINAL)/
 var72O227 (NOMINAL)/
 var72O228 (NOMINAL)/
 var72O229 (NOMINAL)/
 var72O230 (NOMINAL)/
 var72O231 (NOMINAL)/
 var72O232 (NOMINAL)/
 var72O233 (NOMINAL)/
 var72O234 (NOMINAL)/
 var73O235 (NOMINAL)/
 var73O236 (NOMINAL)/
 var73O237 (NOMINAL)/
 var73O238 (NOMINAL)/
 var73O239 (NOMINAL)/
 var73O240 (NOMINAL)/
 var73O241 (NOMINAL)/
 var73O242 (NOMINAL)/
 var73O243 (NOMINAL)/
 var73O244 (NOMINAL)/
 var74O245 (NOMINAL)/
 var74O246 (NOMINAL)/
 var74O247 (NOMINAL)/
 var74O248 (NOMINAL)/
 var74O249 (NOMINAL)/
 var74O250 (NOMINAL)/
 var74O251 (NOMINAL)/
 var74O252 (NOMINAL)/
 var74O253 (NOMINAL)/
 var74O254 (NOMINAL)/
 var75O255 (NOMINAL)/
 var75O256 (NOMINAL)/
 var75O257 (NOMINAL)/
 var75O258 (NOMINAL)/
 var75O259 (NOMINAL)/
 var75O260 (NOMINAL)/
 var75O261 (NOMINAL)/
 var75O262 (NOMINAL)/
 var75O263 (NOMINAL)/
 var75O264 (NOMINAL)/
 var76O265 (NOMINAL)/
 var76O266 (NOMINAL)/
 var76O267 (NOMINAL)/
 var76O268 (NOMINAL)/
 var76O269 (NOMINAL)/
 var76O270 (NOMINAL)/
 var76O271 (NOMINAL)/
 var76O272 (NOMINAL)/
 var76O273 (NOMINAL)/
 var76O274 (NOMINAL)/
 var77O275 (NOMINAL)/
 var77O276 (NOMINAL)/
 var77O277 (NOMINAL)/
 var77O278 (NOMINAL)/
 var77O279 (NOMINAL)/
 var77O280 (NOMINAL)/
 var77O281 (NOMINAL)/
 var77O282 (NOMINAL)/
 var77O283 (NOMINAL)/
 var77O284 (NOMINAL)/
 var78O285 (NOMINAL)/
 var78O286 (NOMINAL)/
 var78O287 (NOMINAL)/
 var78O288 (NOMINAL)/
 var78O289 (NOMINAL)/
 var78O290 (NOMINAL)/
 var78O291 (NOMINAL)/
 var78O292 (NOMINAL)/
 var78O293 (NOMINAL)/
 var78O294 (NOMINAL)/
 var80O197 (SCALE)/
 var80O198 (SCALE)/
 var80O207 (SCALE)/
 var80O208 (SCALE)/
 var80O209 (SCALE)/
 var80O210 (SCALE)/
 var80O211 (SCALE)/
 var80O212 (SCALE)/
 var80O213 (SCALE)/
 var81O215 (SCALE)/
 var81O216 (SCALE)/
 var81O218 (SCALE)/
 var81O219 (SCALE)/
 var81O220 (SCALE)/
 var81O221 (SCALE)/
 var81O222 (SCALE)/
 var81O223 (SCALE)/
 var82O225 (SCALE)/
 var82O226 (SCALE)/
 var82O227 (SCALE)/
 var82O228 (SCALE)/
 var82O229 (SCALE)/
 var82O230 (SCALE)/
 var82O231 (SCALE)/
 var82O232 (SCALE)/
 var82O233 (SCALE)/
 var83O235 (SCALE)/
 var83O236 (SCALE)/
 var83O237 (SCALE)/
 var83O238 (SCALE)/
 var83O239 (SCALE)/
 var83O240 (SCALE)/
 var83O241 (SCALE)/
 var83O242 (SCALE)/
 var83O243 (SCALE)/
 var84O245 (SCALE)/
 var84O246 (SCALE)/
 var84O247 (SCALE)/
 var84O248 (SCALE)/
 var84O249 (SCALE)/
 var84O250 (SCALE)/
 var84O251 (SCALE)/
 var84O252 (SCALE)/
 var84O253 (SCALE)/
 var85O255 (SCALE)/
 var85O256 (SCALE)/
 var85O257 (SCALE)/
 var85O258 (SCALE)/
 var85O259 (SCALE)/
 var85O260 (SCALE)/
 var85O262 (SCALE)/
 var85O263 (SCALE)/
 var86O265 (SCALE)/
 var86O266 (SCALE)/
 var86O267 (SCALE)/
 var86O269 (SCALE)/
 var86O270 (SCALE)/
 var86O271 (SCALE)/
 var86O272 (SCALE)/
 var86O273 (SCALE)/
 var87O275 (SCALE)/
 var87O276 (SCALE)/
 var87O277 (SCALE)/
 var87O278 (SCALE)/
 var87O279 (SCALE)/
 var87O281 (SCALE)/
 var87O282 (SCALE)/
 var87O283 (SCALE)/
 var88O285 (SCALE)/
 var88O286 (SCALE)/
 var88O287 (SCALE)/
 var88O288 (SCALE)/
 var88O289 (SCALE)/
 var88O290 (SCALE)/
 var88O291 (SCALE)/
 var88O292 (SCALE)/
 var88O293 (SCALE)/
 var9 (NOMINAL)/
 var10 (NOMINAL)/
 var11 (NOMINAL)/
 var12 (NOMINAL)/
 var12O59Othr (NOMINAL)/
 var13 (NOMINAL) .


