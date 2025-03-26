# class to make direct request using rack
# to test the rails controller
class RequestHelpers
  REQUEST_DEFAULTS = {
    "HTTP_HOST" => "test.host",
    "REMOTE_ADDR" => "0.0.0.0",
    "HTTP_USER_AGENT" => "Rails Testing",
    "CONTENT_TYPE" => "application/json"
  }.freeze

  def self.execute(method, controller, action, data = {}, bearer)
    headers = REQUEST_DEFAULTS.merge("HTTP_AUTHORIZATION" => "Bearer #{bearer}")
    env = Rack::MockRequest.env_for "/", headers.merge(method: method, input: data.to_json)
    req = ActionDispatch::Request.new env
    res = ActionDispatch::Response.create
    res.request = req
    controller.dispatch(action, req, res)
    json = JSON.parse(res.body) rescue nil
    {
      request: res,
      body: json
    }
  end
end
