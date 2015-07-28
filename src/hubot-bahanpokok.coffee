# Description
#   A hubot script that tells you ingredient prices in cities in Indonesia using data from data.blankon.id
#
# Commands:
#   hubot harga bahan pokok di <cities> - <what the respond trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Didik Wicaksono[@<org>]

module.exports = (robot) ->
  robot.respond /harga bahan(\spokok\s)?di (.*)/, (msg) ->
    city = msg.match[1]
    msg.reply "Harga bahan pokok di #{city}"
