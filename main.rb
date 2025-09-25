# typed: true

require 'dotenv/load'
require 'discordrb'

intents = Discordrb::UNPRIVILEGED_INTENTS + 32768 # read message intent
messages = Array.new
messageAmount = (ENV['MESSAGE_COUNT'] ||= 20.to_s).to_i # gotta be a better way man

bot = Discordrb::Commands::CommandBot.new token: ENV['BOT_TOKEN'], intents: [intents], prefix: '!'

# called when a message is sent in a channel
bot.message do |event|
  # store value in list

  if messages.count >= messageAmount
    messages.delete_at(0)
  end

  if event.message.content != '<@1419551017606844458>'
    messages << event.message.content
  end
end

# called if the bot is *directly mentioned*, i.e. not using a role mention or @everyone/@here.
bot.mention do |event|
  # send a message in response to the bot being mentioned
  messages.each{|x| event.respond(x)}
end

begin
  puts 'Starting bot...'
  bot.run
rescue Interrupt => _e
  puts "\nReceived interrupt, shutting down gracefully..."
  bot.stop
  puts 'Shutdown complete'
end