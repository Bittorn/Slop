require 'dotenv/load'
require 'discordrb'

bot = Discordrb::Bot.new(token: ENV['BOT_TOKEN'])

# called if the bot is *directly mentioned*, i.e. not using a role mention or @everyone/@here.
bot.mention do |event|
  # send a message in response to the bot being mentioned
  event.respond!(content: 'Pong!')
end

# output the invite URL to the console so the bot account can be invited to the server/channel.
puts "This bot's invite URL is #{bot.invite_url}"
puts 'Click on it to invite it to your server.'

bot.run