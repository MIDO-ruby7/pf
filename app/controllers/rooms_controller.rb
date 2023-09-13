class RoomsController < ApplicationController
  layout 'timeline'

  def create
    @message = current_user.messages.build(message_params)
    content = @message.content
    client = ::OpenAI::Client.new

    if @message.save
      response_content = Openai.openai_response(content)  # AIからのレスポンスを生成
      @message.update(boo_response: response_content) # AIからのレスポンスを保存
      render_message_and_broadcast(@message)
      render json: { message: render_to_string(partial: 'messages/message', locals: { message: @message }) }
    else
      render json: { error: @message.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def show
    @message = Message.new
    @messages = Message.includes(:user).all
    @stamps = Stamp.all
    @acitive_stamp = MessageStampRelationship.includes(:stamp).all
  end

  private

  def message_params
    params.require(:message).permit(:content, :user_id, :boo_response)
  end

  def render_message_and_broadcast(message)
    rendered_message = ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
    ActionCable.server.broadcast('room_channel', { message: rendered_message, boo_response: message.boo_response })
  end
end
