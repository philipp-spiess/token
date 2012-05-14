###
  Auth mechanism
###

module.exports = (req, res, fn) -> 
  if req.session.auth? and req.session.auth.loggedIn?
    fn? req.session.auth.github.user
  else
    res.redirect '/auth'