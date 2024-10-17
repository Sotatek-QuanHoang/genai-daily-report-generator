# frozen_string_literal: true

require 'dotenv/load'
require 'gemini-ai'

# With an API key
client = Gemini.new(
  credentials: {
    service: 'generative-language-api',
    api_key: ENV['GOOGLE_GEMINI_TOKEN']
  },
  options: { model: 'gemini-pro', server_sent_events: true }
)

result = client.stream_generate_content({
  contents: { role: 'user', parts: { text: '日報例文を書いてください' } }
})

mail_template = result
              .map { |response| response.dig('candidates', 0, 'content', 'parts') }
              .map { |parts| parts.map { |part| part['text'] }.join }
              .join

puts mail_template
