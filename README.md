glitter
=======

![Sample Visualization](https://github.com/justinkamerman/glitter/master/sample/benioff.png)

Motivation
----------
Everybody tweets these days but not all tweets are created equal, and
neither are tweeters for that matter. One of the truest measures of a
tweet and, by proxy, the tweeter, is how far into the social-graph the
message propagates via retweeting. Retweeting is an explicit
indication of engagement on the part of the retweeter and in most
cases, an endorsement of the message and the original author. That all
said, it is an interesting exercise to see where in the social-graph a
particular tweet reached. The Twitter API makes it easy to tell how
many times and by whom a message was retweeted but it takes a bit more
legwork to determine the path taken to the recipients.

A simple method to follow the propagation of a tweet is to do a
breadth-first traversal of followers links, starting at the message
author, until all retweeters have been accounted for. Obviously there
are some assumptions wrapped up in this methodology but for the most
part evidence supports the results. The Python script below performs
this walk through the social graph. For economy against the Twitter
API, the script caches follower lists in a Redis server so that they
may be re-used for subsequent runs. This scheme works best when
examining tweets which are closely related and incorporate many of the
same Twitter users.

For visualization purposes, the Python script outputs a JSON file for
consumption by a D3 force-directed graph template. D3 expects nodes
and links enumerated in separate lists, the link elements making
reference to the node elements via node list indices. 

While the ability to gather broad insight with this method is limited
by Twitter API rate controls, it could be used to do a focused study
on a specific Twitter user, looking for prominent social-graph
pathways and individuals that warrant reciprocation. Failing that, the
D3 transitions as the graph builds and stabilizes makes fascinating
viewing.

Installing
----------
To get it running on your machine, do the following:

* Install [Node](http://nodejs.org/) 
* Make sure NPM is installed too (type `npm help`), if not get it from [here](https://github.com/isaacs/npm)
* In the web folder run `npm install`
* Then run `node index.js`
