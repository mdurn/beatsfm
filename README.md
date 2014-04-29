# BeatsFM

BeatsFM is an unofficial (3rd party) web player for Beats Music that plays top artists and recommendations from a user's Last.fm account. Tracks are scrobbled to Last.fm when 50% of the track is completed. A Beats Music subscription and Last.fm account are required to use the site.

###Website

[http://beats-fm.com](http://www.beats-fm.com)

###Additional Details

The player first fetches a mix of a Last.fm user's [top artists](http://www.last.fm/api/show/user.getTopArtists) and [recommended artists](http://www.last.fm/api/show/user.getRecommendedArtists). Then, random popular tracks from those artists are streamed from Beats Music.

Tracks can be skipped, fast-forwarded, or rewound. After 50% of the track is played, it is scrobbled to Last.fm.

![](http://api.mixpanel.com/track/?data=eyJldmVudCI6IlJlcG9zaXRvcnkgVmlld2VkIiwicHJvcGVydGllcyI6eyJ0b2tlbiI6Ijg2YWQ3Mjc5YmQzMGQ2MDMzMzQ0NjYwMDY3YzA1MTg1IiwiY2FtcGFpZ24iOiJiZWF0c2ZtIn0=&ip=1&img=1)
![](http://www.pixelsite.info/track/t19137.gif)
