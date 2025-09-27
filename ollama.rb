# typed: true

require "rest-client"
require "json"


# returns true if model was successfully pulled or was already available
def pull model
  begin
    query = RestClient.post 'http://localhost:11434/api/pull', {model: model}
    response = JSON.parse query
    return response['status'] == 'success' # TODO: verify this is true when model is still available
  rescue
    puts 'Could not contact Ollama'
    return false
  end
end

def query model, prompt
  begin
    query = RestClient.post 'http://localhost:11434/api/generate', {
      model: model,
      prompt: prompt,
      stream: false
    }
    response = JSON.parse query
    return response['response']
  rescue
    return 'Error'
  end
end