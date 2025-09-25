# typed: true

require 'dotenv/load'
require 'discordrb'

intents = Discordrb::UNPRIVILEGED_INTENTS + 32768 # read message intent
messages = Array.new
messageAmount = (ENV['MESSAGE_COUNT'] ||= 20.to_s).to_i # gotta be a better way man
adminId = ENV['ADMIN_ID']

puts "Message amount set to #{messageAmount}\n"

bot = Discordrb::Commands::CommandBot.new token: ENV['BOT_TOKEN'], intents: [intents], prefix: '!'

bot.command :slop, help_available: false do |event|

  event << '👋'
  event << "Hi, I'm Slop!"
  event << '🤖'
  event << "I'm a bot that responds to messages with a single emoji."
  event << '💬'
  event << "Just @ me to try me out!\n"
  event << '⚠️'
  event << "(I don't actually process messages yet, but soon)"

  # commands send whatever is returned from the block to the channel
  # don't have to worry about return value here because `event << line` automatically returns nil
end

bot.command :exit, help_available: false do |event|
  break unless event.user.id == adminId.to_i

  event.respond '🖖'
  exit
end

# called when a message is sent in a channel
bot.message do |event|
  # store value in list

  if messages.count >= messageAmount
    messages.delete_at 0
  end

  if event.message.content != '<@1419551017606844458>'
    messages << event.message.content
  end
end

# called if the bot is *directly mentioned*, i.e. not using a role mention or @everyone/@here
bot.mention do |event|
  # send a message in response to the bot being mentioned
  event.respond '👍'
end

def shutdown bot, reason
  puts "Received #{reason}, shutting down gracefully..."
  bot.stop
  puts 'Shutdown complete'
end

begin
  puts 'Starting bot...'
  bot.run
rescue Interrupt
  shutdown bot, 'interrupt'
rescue SystemExit
  shutdown bot, 'exit'
end