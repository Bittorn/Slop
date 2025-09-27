# typed: true

require 'dotenv/load'
require 'discordrb'

require_relative 'ollama'

intents = Discordrb::UNPRIVILEGED_INTENTS + 32768 # read message intent
messages = Array.new
adminId = ENV['ADMIN_ID'].to_i
messageAmount = (ENV['MESSAGE_COUNT'] ||= 20.to_s).to_i # gotta be a better way man
puts "Message amount set to #{messageAmount}\n"
ollamaModel = ENV['OLLAMA_MODEL'] ||= 'embeddinggemma:300m'
ollamaPrompt = ENV['OLLAMA_PROMPT'] ||= 'whatever'
puts "Ollama model set to #{ollamaModel}\n"

fallbackEmoji = ['🔥', '👍', '👎', '🦭', '🤷', '💀', '🗣️', '🤡'] # TODO: load from file

bot = Discordrb::Commands::CommandBot.new token: ENV['BOT_TOKEN'], intents: [intents], prefix: '!slop '

bot.command :help, help_available: false do |event|
  # TODO: spruce this up

  event.send_temp "👋 Hi, I'm Slop!\n🤖 I'm a bot that responds to messages with a single emoji.\n💬 Just @ me to try me out!"
  return nil

  # commands send whatever is returned from the block to the channel
end

# kills the bot on command
bot.command :exit, help_available: false do |event|
  break unless event.user.id == adminId

  event.send_temp '🖖'
  exit
end

# ensures LLM model is pulled
bot.command :setup, help_available: false do |event|
  break unless event.user.id == adminId

  msg = event.send_temp '🤖 Pulling image...'
  if pull ollamaModel
    msg.edit '🤖 Successfully pulled image.'
  else
    msg.edit '🤖 Unable to pull image.'
  end
  
  return nil
end

# called when a message is sent in a channel
bot.message do |event|
  # store value in list

  if messages.count >= messageAmount
    messages.delete_at 0
  end

  if event.message.content != '<@1419551017606844458>' # TODO: make this not hard-coded
    messages << event.message.content
  end
end

# called if the bot is *directly mentioned*, i.e. not using a role mention or @everyone/@here
bot.mention do |event|
  # send a message in response to the bot being mentioned

  # fallback message if API response cannot be parsed
  event.respond fallbackEmoji[rand fallbackEmoji.count]
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