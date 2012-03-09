module.exports = (robot) ->
  robot.hear /laura/i, (msg) ->
    msg.send("No!! Not her!")
