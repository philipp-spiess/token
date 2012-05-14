###
  Github strategy for everyauth using api V3 ;)
###

everyauth = require 'everyauth'

everyauth.debug = true

# GitHub OAuth
# 
# @Todo Save into something like Redis
users = {}

everyauth.github
  .entryPath('/auth')
  .apiHost('https://api.github.com/')
  .appId(process.env.GITHUB_CLIENT_ID)
  .appSecret(process.env.GITHUB_SECRET)
  .redirectPath('/')
  
  .fetchOAuthUser (accessToken) ->
    p = this.Promise()
    that = this
    that.oauth.get that.apiHost() + 'user', accessToken, (err, data) ->
      if (err)
        return p.fail err

      oauthUser = JSON.parse data
      oauthUser.token = accessToken
      p.fulfill oauthUser

    return p

  .findOrCreateUser (sess, accessToken, accessTokenExtra, user) ->
    unless users[user.id]?
      users[user.id] = user

    users[user.id]

module.exports = everyauth

