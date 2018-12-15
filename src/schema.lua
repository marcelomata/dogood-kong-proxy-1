local url = require "socket.url"

local function validate_url(value)
  local parsed_url = url.parse(value)
  if parsed_url.scheme and parsed_url.host then
    parsed_url.scheme = parsed_url.scheme:lower()
    if not (parsed_url.scheme == "http" or parsed_url.scheme == "https") then
      return false, "Supported protocols are HTTP and HTTPS"
    end
  end

  return true
end

return {
  fields = {
    authorize_url = {type = "url", required = true, func = validate_url},
    token_url = {type = "url", required = true, func = validate_url},
    user_url  = {type = "url", required = true, func = validate_url},
    log_file = {type = "url", default = "/tmp/dogood-test.log"},
  }
}