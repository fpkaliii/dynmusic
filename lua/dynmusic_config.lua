// CONFIG \\

dynamicMusic = { // i suggest uploading files to your own webserver for the music links
	ambientMusic = { // ambient music url(s) -- played when not in combat/darkness, must be a direct link to mp3/wav/etc.
		"https://a.pomf.cat/zjjyzd.mp3",
	},

	darkMusic = { // dark music url(s) -- played when not in combat but in darkness, must be a direct link to mp3/wav/etc.
		"https://a.pomf.cat/tkskyu.mp3",
	},

	fightMusic = { // fight music url(s) -- played when in combat, must be a direct link to mp3/wav/etc.
		"https://a.pomf.cat/iszbkm.mp3",
	},

	darkResetTime = 6, // how long to wait before resetting music time for dark areas

	fightPerformance = false, // true/false, true == more perfomance in combat detection, false == less performance but much more responsive combat detection
}
