# frozen_string_literal: true

class Result
  attr_reader :payload, :error, :code

  def self.success(payload: {})
    new(success: true, payload: payload)
  end

  def self.failure(error:, code: nil, payload: {})
    new(success: false, error: error, code: code, payload: payload)
  end

  def initialize(success:, payload:, error: nil, code: nil)
    @success = success
    @payload = payload
    @error = error
    @code = code
  end

  def success?
    @success
  end

  def failure?
    !success?
  end

  def post
    payload[:post]
  end

  def comment
    payload[:comment]
  end
end
