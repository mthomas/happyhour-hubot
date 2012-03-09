module.exports = (robot) ->
  robot.hear /^find (.*) (near|in) (.*)$/i, (msg) ->

    console.log "The matches:", msg.match

    query = encodeURIComponent(msg.match[1])
    address = encodeURIComponent(msg.match[3])
      
    url = "http://api.yelp.com/business_review_search?term=#{query}&location=#{address}&ywsid=#{process.env.HUBOT_YWSID}"

    console.log "URL for yelp: " + url

    msg.http(url).get() (err, res, body) ->
      data = JSON.parse(body)

      console.log "response from yelp: " + body

      results = data?.businesses

      if not results?
        msg.send "No results for #{msg.match[1]}"
        return

      for r in results
        msg.send "#{r.name} (#{r.avg_rating} stars with #{r.review_count} reviews): #{r.url}"  