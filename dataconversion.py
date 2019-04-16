import json, urllib.request, csv


# get list of game IDs (created in R)
with open('gameIDs.csv', newline = '') as csvFile:
	mycsv = csv.reader(csvFile, delimiter = ',')
	mycsv = list(mycsv)
	csvFile.close()

# have to flatten list because the csv imports as a nested list
flattened = [val for sublist in mycsv for val in sublist]
flattened.pop(0)
# print(str(flattened))

d = [['game', 'home_team', 'away_team', 'shooter', 'shooterCode', 'team', 'home_away', 'x_coord', 'y_coord', 'period', 'periodType', 'periodTime', 'periodTimeRemaining', 'result', 'primaryAssist', 'paCode', 'secondaryAssist', 'saCode', 'strength']]

for game in flattened:

	u = ['https://statsapi.web.nhl.com/api/v1/game/', str(game), '/feed/live']
	u = ''.join(u)

	with urllib.request.urlopen(str(u)) as url:
		data = json.loads(url.read().decode())

	events = data['liveData']['plays']['allPlays']


	hometeam = data['gameData']['teams']['home']['triCode']
	awayteam = data['gameData']['teams']['away']['triCode']


	# this works for creating columns, but I really need to create rows
	for i in events:
		if i['result']['event'] in ['Shot', 'Goal']:
			# this is a shot
			# get shooter, team, x and y coordinates, period, time, home/away (because will need to reverse coordinates)
			# players, result, about, coordinates, team

			shot = list() # list obj for this shot

			shot.append(game) # game
			shot.append(hometeam) # home
			shot.append(awayteam) # away 

			# shooter
			shot.append(i['players'][0]['player']['fullName'])
			shot.append(i['players'][0]['player']['id'])
			
			# team
			t = i['team']['triCode']
			shot.append(t)

			# home/away
			if t == hometeam:
				shot.append('Home')
			else:
				shot.append('Away')

			# coordinates
			try:
				shot.append(i['coordinates']['x'])
				shot.append(i['coordinates']['y'])
			except KeyError:
				next # if you don't have coordinates for x and y, skip it

			# period
			shot.append(i['about']['period'])
			shot.append(i['about']['periodType']) # regulation vs OT

			# time
			shot.append(i['about']['periodTime']) # counting up, not down
			shot.append(i['about']['periodTimeRemaining'])

			# result
			if i['result']['event'] == 'Shot':
				shot.append(0) # no goal
				shot.append('NA') # primary assist
				shot.append('NA') # primary assist code
				shot.append('NA') # secondary assist
				shot.append('NA') # secondary assist code
				shot.append('NA') # strength
			else: 
				shot.append(1) # goal
				try:
					shot.append(i['players'][1]['player']['fullName']) # primary assist
					shot.append(i['players'][1]['player']['id']) # primary code
				except IndexError: 
					shot.append('NA') # no primary 
					shot.append('NA') # no primary code
					shot.append('NA') # no secondary
					shot.append('NA') # no secondary code
				try:
					shot.append(i['players'][2]['player']['fullName']) # secondary
					shot.append(i['players'][2]['player']['id']) # secondary code
				except IndexError:
					shot.append('NA') # no secondary
					shot.append('NA') # no secondary code
				
				shot.append(i['result']['strength']['code']) # even, power play, or shorthand

			d.append(shot)



with open('locationData.csv', 'w') as csvFile:
	writer = csv.writer(csvFile)
	writer.writerows(d)

csvFile.close()




