# frozen_string_literal: true

# app/services/ai_comment_service.rb
class AiCommentService
  def self.generate_comment(post_content)
    client = OpenAI::Client.new(access_token: ENV.fetch('OPENAI_API_KEY', nil))

    response = client.chat(
      parameters: {
        model: 'gpt-4o', # または gpt-4-turbo など
        messages: [
          { role: 'system', content: 'あなたは栄養士で、投稿料理を低カロリーにする工夫やおすすめポイントを提案します。' },
          { role: 'user', content: "この投稿内容を元に提案をお願いします: #{post_content}" }
        ],
        temperature: 0.7
      }
    )

    response.dig('choices', 0, 'message', 'content')
  rescue StandardError => e
    Rails.logger.error("OpenAI API error: #{e.message}")
    nil
  end
end
