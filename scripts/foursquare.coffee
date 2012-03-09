module.exports = (robot) ->
  robot.hear /^(.*) near (.*)$/i, (msg) ->

    console.log "The matches:", msg

    address = encodeURIComponent(msg.match[1])
    query = encodeURIComponent(msg.match[0])

    url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{address}&sensor=false"

    msg
      .http(url)
      .get() (err, res, body) ->
        console.log "Google URL: " + url
        console.log "RESPONSE FROM GOOGLE: " + body
        geocodeData = JSON.parse(body)

        lat = geocodeData.results[0].geometry.location.lat
        lng = geocodeData.results[0].geometry.location.lng

        url = "https://api.foursquare.com/v2/venues/search?ll=#{lat},#{lng}&radius=1000&query=#{query}&client_id=#{process.env.HUBOT_FSQ_CLIENT_ID}&client_secret=#{process.env.HUBOT_FSQ_CLIENT_SECRET}&v=20120308"

        msg
          .http(url)
          .get() (err, res, body) ->
            fsqData = JSON.parse(body)

            venues = fsqData.response.venues

            for venue in venues
              msg.send venue.name


