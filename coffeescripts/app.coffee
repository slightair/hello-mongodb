mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

mongoose.connect 'mongodb://localhost/hello-mongodb'

TweetSchema = new Schema
    id: ObjectId
    username: String
    text:
        type: String
    date:
        type: Date
        default: Date.now

Tweet = mongoose.model 'Tweet', TweetSchema

TweetSchema.path('text').validate((v, result) ->
    Tweet.find {username: @username}, (err, tweets) ->
        return false if err
        
        for t in tweets
            if t.text == v
                result false
                return
        result true
, 'unique text')

step = (callbacks, done) ->
    counter = callbacks.length
    next = ->
        counter -= 1
        done() if counter == 0
    callback(next) for callback in callbacks

step [
    (next) ->
        myTweet = new Tweet
        myTweet.username = 'slightair'
        myTweet.text = 'hello mongodb!'
        myTweet.save (err) ->
            console.log err.message if err
            next()
    (next) ->
        otherTweet = new Tweet
        otherTweet.username = 'hoge'
        otherTweet.text = 'hello mongodb!'
        otherTweet.save (err) ->
            console.log err.message if err
            next()
], ->
    Tweet.find {username: 'slightair'}, (err, tweets) ->
        if err
            console.log err.message
            return
        console.log "@#{t.username}: #{t.text} [#{t.date}]" for t in tweets
