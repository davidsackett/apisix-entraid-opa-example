package httpapi.authz

import input.request

default allow = false

allow {
    is_token_valid
    request.method == "GET"
    request.path == "/anything"
}

is_token_valid {
    [_, payload, _] := io.jwt.decode(bearer_token)
    print("payload:", payload)
    payload.aud == my_env.CLIENT_ID
    payload.iss == sprintf("https://login.microsoftonline.com/%s/v2.0", [my_env.TENANT_ID])
}

bearer_token := t {
	v := request.headers.authorization
	startswith(v, "Bearer ")
	t := substring(v, count("Bearer "), -1)
}