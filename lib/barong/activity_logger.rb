# frozen_string_literal: true

module Barong
  # admin activities log writer class
  class ActivityLogger
    ACTION = { post: 'create', put: 'update', get: 'list', delete: 'delete' }.freeze

    def self.write(options = {})
      @activities ||= Queue.new
      @activities.push(options)

      @thread ||= Thread.new do
        begin
          loop do
            msg = @activities.pop
            Activity.create!(format_params(msg))
          end
        rescue => exception
          Rails.logger.error { "Failed to create activity: #{exception.inspect}" }
        end
      end
    end

    def self.format_params(params)
      topic = params[:topic].nil? ? params[:path].split('/admin/')[1].split('/')[0] : params[:topic]
      {
        user_id:       params[:user_id],
        target_uuid:   params[:payload][:uid] || params[:payload][:user_uid] || '',
        user_ip:       params[:user_ip],
        user_agent:    params[:user_agent],
        topic:         topic,
        action:        ACTION[params[:verb].downcase.to_sym],
        result:        params[:result],
        category:      'admin'
      }
    end
  end
end
