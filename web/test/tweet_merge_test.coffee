tweet1 =
  "tweet":
    "text": "Tweet1",
    "retweet_count": 1,
    "id": 1,
    "author": 1
  "nodes": [
    "followers_count": 1,
    "id": 1,
    "screen_name": "user1"
  ,
    "followers_count": 2,
    "id": 2,
    "screen_name": "user2"
  ,
    "followers_count": 3,
    "id": 3,
    "screen_name": "user3"
  ]
  "links": [
    "source": 0,
    "target": 1
  ,
    "source": 0,
    "target": 2
  ]

tweet2 =
  "tweet":
    "text": "Tweet2",
    "retweet_count": 2,
    "id": 2,
    "author": 1
  "nodes": [
    "followers_count": 1,
    "id": 1,
    "screen_name": "user1"
  ,
    "followers_count": 2,
    "id": 2,
    "screen_name": "user2"
  ,
    "followers_count": 4,
    "id": 4,
    "screen_name": "user4"
  ]
  "links": [
    "source": 0,
    "target": 1
  ,
    "source": 0,
    "target": 2
  ]

describe 'TweetMerge', ->
  describe 'merging a simple data set', ->
    merger = new TweetMerge(tweet1, tweet2)
    merged = merger.merge()

    it 'should collect the individual tweets in a set', ->
      expect(merged.tweets).toEqual([
        { text : 'Tweet1', retweet_count : 1, id : 1, author : 1 },
        { text : 'Tweet2', retweet_count : 2, id : 2, author : 1 }
      ])

    it 'should be able to merge all the nodes and annotate them with counts', ->
      expect(merged.nodes).toEqual([
        { followers_count : 1, id : 1, screen_name : 'user1', count : 2 },
        { followers_count : 2, id : 2, screen_name : 'user2', count : 2 },
        { followers_count : 3, id : 3, screen_name : 'user3', count : 1 },
        { followers_count : 4, id : 4, screen_name : 'user4', count : 1 }
      ])

    it 'should be able to retain proper link connections', ->
      expect(merged.links).toEqual([
        { source: 0, target: 1 },
        { source: 0, target: 2 },
        { source: 0, target: 3 }
      ])
