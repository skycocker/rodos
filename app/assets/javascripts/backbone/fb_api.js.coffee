window.fbAsyncInit = ->
  FB.init
    appId: "377463792337692"
    status: true
    cookie: true
    xfbml: true

  FB.getLoginStatus (response) ->
    if response.status is "connected"
      FB.api "/me/groups", (response) ->
        window.fbUserGroups = response.data
        $(document).trigger("fbApiReady")
          
((d, debug) ->
  js = undefined
  id = "facebook-jssdk"
  ref = d.getElementsByTagName("script")[0]
  return  if d.getElementById(id)
  js = d.createElement("script")
  js.id = id
  js.async = true
  js.src = "//connect.facebook.net/pl_PL/all" + ((if debug then "/debug" else "")) + ".js"
  ref.parentNode.insertBefore js, ref
) document, false
