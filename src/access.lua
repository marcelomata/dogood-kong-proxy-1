

local _M = {}
local cjson = require "cjson.safe"
local pl_stringx = require "pl.stringx"
local http = require "resty.http"
local crypto = require "crypto"
local print_table = require 'pl.pretty'

local responses = require "kong.tools.responses"

function _M.run(conf)

    -- Here will be performed the authentication and authorization calls to the oauth server
    local httpc = http:new()
    local res, err = httpc:request_uri(conf.token_url, {
        method = "GET",
        headers = {
            ["Content-Type"] = "application/json",
        }
    })

    print('###################### Dump of conf)')
    print(print_table.dump(conf))
    print('###################### Dump of ngx)')
    print(print_table.dump(ngx))
    local callback_url = ngx.var.scheme .. "://" .. ngx.var.host ..  ":" .. ngx.var.server_port .. ngx.var.request_uri 
    print('###################### Print ngx.var.scheme .. "://" .. ngx.var.host ..  ":" .. ngx.var.server_port .. ngx.var.request_uri)')
    print(callback_url)
    print('###################### Dump of ngx.ctx)')
    print(print_table.dump(ngx.ctx))
    print('###################### Dump of ngx.var)')
    print(print_table.dump(ngx.var))
    print('###################### Dump of ngx.ctx.balancer_data)')
    print(print_table.dump(ngx.ctx.balancer_data))
    print('###################### Dump of ngx.ctx.service)')
    print(print_table.dump(ngx.ctx.service))
    print('###################### Dump of ngx.ctx.api)')
    print(print_table.dump(ngx.ctx.api))
    print('###################### Dump of ngx.req)')
    print(print_table.dump(ngx.req))
    print('###################### Dump of ngx.ctx.api.hosts)')
    print(print_table.dump(ngx.ctx.api.hosts))
    print('###################### Print of ngx.ctx.api.id)')
    print(ngx.ctx.api.id)
    print('###################### Print of ngx.ctx.api.upstream_url)')
    print(ngx.ctx.api.upstream_url)
    print('###################### Dump of ngx.req.get_headers())')
    headers =  ngx.req.get_headers()
    print(print_table.dump(headers))
    print('###################### Print of headers["Host"]')
    print(headers["Host"])

    local httpc = http:new()
    local res, err = httpc:request_uri(callback_url, {
        method = "GET",
        headers = {
            ["Content-Type"] = "application/json",
        }
    })
    
    -- Here will be performed the call to the api
    local httpc = http:new()
    local res, err = httpc:request_uri(conf.token_url, {
        method = "GET",
        headers = {
            ["Content-Type"] = "application/json",
        }
    })    

    return responses.send(200, 'Ok')

    
end

-- function encode_token(token, conf)
--     return ngx.encode_base64(crypto.encrypt("aes-128-cbc", token, crypto.digest('md5',conf.client_secret)))
-- end

-- function decode_token(token, conf)
--     status, token = pcall(function () return crypto.decrypt("aes-128-cbc", ngx.decode_base64(token), crypto.digest('md5',conf.client_secret)) end)
--     if status then
--         return token
--     else
--         return nil
--     end
-- end


return _M
