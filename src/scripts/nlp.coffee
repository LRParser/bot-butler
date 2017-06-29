
# Relevant server at https://github.com/LRParser/nlp-server

module.exports = (robot) ->
  robot.hear /settopic (.*)/i, (msg) ->
    robot.http(encodeURI("http://localhost:5000/settopic?topic=#{msg.match[1]}"))
    .header('Accept', 'application/json')
    .get() (err, res, body) ->
      if err
        msg.send "Failed to set topic to: #{msg.match[1]}"
      else
        try
          json = JSON.parse(body)
          msg.send {
            format: 'MESSAGEML'
            text: "<messageML>OK, I will follow and set baseline to: #{msg.match[1]}</messageML>"
          }
        catch error
          msg.send "Failed to process set topic response: #{msg.match[1]}"

  robot.hear /(.*)$/i, (msg) ->
    if(msg.match[1].indexOf("settopic") == -1)
      robot.http(encodeURI("http://localhost:5000/comparewith?phrase=#{msg.match[1]}"))
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        if err
          msg.send "Failed to rate new phrase of #{msg.match[1]}"
        else
          try
            json = JSON.parse(body)
            msg.send {
              format: 'MESSAGEML'
              text: "<messageML>#{json.phrase} has similarity of #{json.result} with #{json.topic}, do you want to see it?</messageML>"
            }
          catch error
            msg.send "Failed to process response for #{msg.match[1]}"
