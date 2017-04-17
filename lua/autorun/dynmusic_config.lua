dynamicMusic = { // i suggest uploading files to your own webserver for the music links
	// CONFIG \\
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
	// END CONFIG \\

	darknessValue = 0.0003, // DON'T EDIT
	enabledCvar = CreateClientConVar("dynamicmusic_enabled", 1), // DON'T EDIT
	volumeCvar = CreateClientConVar("dynamicmusic_volume", 100) // DON'T EDIT
}
