module.exports = (robot) ->
  robot.router.get "/", (req, res) ->
    res.end "Still alive! #{new Date()}" 