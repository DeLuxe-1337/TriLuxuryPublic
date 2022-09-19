--join https://discord.gg/QhG5anvtE5

local req = request or syn.request

req({
   Url = "http://127.0.0.1:6463/rpc?v=1",
   Method = "POST",
   Headers = {
       ["Content-Type"] = "application/json",
       ["Origin"] = "https://discord.com"
   },
   Body = game:GetService("HttpService"):JSONEncode({
       cmd = "INVITE_BROWSER",
       args = {
           code = "QhG5anvtE5"
       },
       nonce = game:GetService("HttpService"):GenerateGUID(false)
   }),
})
