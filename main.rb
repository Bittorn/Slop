require 'dotenv/load'
require 'discordrb'

bot = Discordrb::Bot.new(token: ENV['BOT_TOKEN'])
messages = Array.new

# called when a message is sent in a channel
bot.message do |event|
  # store value in list
  if messages.count >= 5
    messages << event.message.content
  else
    arr.delete_at(0)
    messages << event.message.content
  end
end

# called if the bot is *directly mentioned*, i.e. not using a role mention or @everyone/@here.
bot.mention do |event|
  # send a message in response to the bot being mentioned
  event.respond!(content: 'Pong!')
end

# output the invite URL to the console so the bot account can be invited to the server/channel.
puts "This bot's invite URL is #{bot.invite_url}"
puts 'Click on it to invite it to your server.'

bot.run