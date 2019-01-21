

local _M = {}
local http = require "resty.http"
local ngx_re_match = ngx.re.match
local responses = require "kong.tools.responses"

function _M.run(conf)

    local headers =  ngx.req.get_headers()
    local authorization_header = headers["Authorization"]

    if authorization_header then
        local header_list, iter_err = ngx_re_match(authorization_header, "\\s*[Bb]earer\\s*(.+)")
        if not header_list then
            ngx.log(ngx.ERR, iter_err)
            responses.send(401, 'Token not provided.')
        end

        if header_list and header_list[1] then
            local token = header_list[1]

            local httpc = http:new()
            local res, err = httpc:request_uri(conf.authorize_url , {
                method = "GET",
                headers = {
                    ["Content-Type"] = "application/json",
                    ["Authorization"] = "Baerer "..header_list[1],
                }
            })

            if err or res.status ~= 200 then
                responses.send(res.status, res.body)
            end       

            -- Kong will send up the connection
        else
            responses.send(401, 'Token not provided.')
        end

    else    
        return responses.send(401, 'Token not provided. This service is not allowed to be accessed without authorization.')
    end
    
end

return _M
