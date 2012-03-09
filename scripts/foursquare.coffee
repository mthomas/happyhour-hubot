module.exports = (robot) ->
  robot.hear /^find (.*) (near|in) (.*)$/i, (msg) ->

    console.log "The matches:", msg.match

    query = encodeURIComponent(msg.match[1])
    address = encodeURIComponent(msg.match[2])
    

    url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{address}&sensor=false"

    msg
      .http(url)
      .get() (err, res, body) ->
        console.log "Google URL: " + url
        console.log "RESPONSE FROM GOOGLE: " + body
        geocodeData = JSON.parse(body)

        location = geocodeData?.results?[0]?.geometry?.location

        if not location?
          msg.send "Sorry, I can't find #{msg.match[2]}"
          return

        lat = location.lat
        lng = location.lng

        url = "https://api.foursquare.com/v2/venues/search?ll=#{lat},#{lng}&radius=1000&query=#{query}&client_id=#{process.env.HUBOT_FSQ_CLIENT_ID}&client_secret=#{process.env.HUBOT_FSQ_CLIENT_SECRET}&v=20120308"

        msg
          .http(url)
          .get() (err, res, body) ->
            fsqData = JSON.parse(body)

            venues = fsqData?.response?.venues

            if not venues?
              msg.send "Sorry, I can't find any #{msg.match[1]} near #{msg.match[2]}"
              return

            for venue in venues
              msg.send "#{venue.name}: #{venue.url or 'http://www.foursquare.com/v/' + venue.id}"


