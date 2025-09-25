# Slop

Simple Logographic Output Provider (Slop) is a Discord bot written in Ruby that queries a locally-running AI model and replies to mentions with a single appropriate emoji.

## Ollama

If the bot cannot connect to Ollama, or does not receive a valid formatted response, it will choose from a random selection of emojis and then send one of those. To be honest, users likely won't know the difference.

## Credits

Discord API bindings for Ruby: [discordrb](https://github.com/shardlab/discordrb)

Ruby .env file passing: [dotenv](https://github.com/bkeepers/dotenv)

Icon: [fluentui-emoji - disguised-face](https://github.com/microsoft/fluentui-emoji/blob/main/assets/Disguised%20face/High%20Contrast/disguised_face_high_contrast.svg)
