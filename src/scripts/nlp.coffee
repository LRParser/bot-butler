
# Relevant server at https://github.com/LRParser/nlp-server

module.exports = (robot) ->
  robot.hear /(.*)$/i, (msg) ->
    robot.http("http://localhost:5000?rate_phrase=#{msg.match[1]}")
    .header('Accept', 'application/json')
    .get() (err, res, body) ->
      if err
        msg.send "Failed to rate new phrase up #{msg.match[1]}"
      else
        try
          console.log(res)
          console.log(body)
          json = JSON.parse(body)
          msg.send {
            format: 'MESSAGEML'
            text: "<messageML>#{json}</messageML>"
          }
        catch error
          msg.send "Failed to rate $#{msg.match[1]}"

module.exports = (robot) ->
  robot.hear /followheadline (.*)/i, (msg) ->
    robot.http("http://localhost:5000?rate_phrase=#{msg.match[1]}")
    .header('Accept', 'application/json')
    .get() (err, res, body) ->
      if err
        msg.send "Failed to set topic to: #{msg.match[1]}"
      else
        try
          console.log(res)
          console.log(body)
          json = JSON.parse(body)
          msg.send {
            format: 'MESSAGEML'
            text: "<messageML>OK, I will follow and set baseline to: #{msg.match[1]}</messageML>"
          }
        catch error
        msg.send "Failed to set topic to: #{msg.match[1]}"
