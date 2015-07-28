# Description
#   A hubot script that tells you ingredient prices in cities in Indonesia using data from data.blankon.id
#
# Commands:
#   hubot harga bahan pokok di <cities> - <display ingredients price with price change>
#   hubot tampilkan kota - <display list of available cities to query to>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Didik Wicaksono[@<org>]

module.exports = (robot) ->
  robot.respond /harga bahan(\spokok\s)?di (.*)/, (msg) ->
    city = msg.match[2]
    icons = (delta) ->
      int = parseFloat(delta) / 100.0
      icon = switch
        when int == 0 then ":arrow_right:"
        when int > 0 then ":arrow_up:"
        when int < 0 then ":arrow_down:"
      icon

    msg.http("https://data.blankon.id/api/bahanpokok?q=#{city}").get() (err, res, body) ->
      fields = []
      result = JSON.parse(body)
      for price in result["cities"][0]["prices"]
        unit = price.unit.split "/"
        value = ''
        if price.delta
          value += "#{icons(price.delta)} `#{price.delta}` "
        else
          value += "#{icons(0)} `0` "
        value += "*#{unit[0]} #{price.price} /#{unit[1]}*"
        field =
          title: price.name
          value: value
          short: true
        fields.push field

      robot.emit 'slack.attachment',
        message: msg.message,
        content:
          pretext: "Harga bahan pokok di #{city} dari *#{result.period.domestic.from}* sampai *#{result.period.domestic.to}*"
          fallback: "Harga bahan pokok di #{city}"
          fields: fields
          mrkdwn_in: ["pretext", "fields"]

  robot.respond /tampilkan kota/, (msg) ->
    msg.http("https://data.blankon.id/api/bahanpokok/cities").get() (err, res, body) ->
      cities = []
      for city in JSON.parse(body)["supportedCities"]
        cities.push city

      robot.emit 'slack.attachment',
        message: msg.message,
        content:
          pretext: "Kota-kota dengan informasi bahan pokok"
          fallback: "Kota-kota dengan informasi bahan pokok"
          text: cities.join("\n")
          mrkdwn_in: ["pretext"]
