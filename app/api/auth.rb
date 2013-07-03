module Tribute
  module Api
    class Auth < Grape::API
      format :json

      content_type :html, "text/html"
      formatter :html, nil

      get "/auth/handshake" do
        # TODO: check target
        content_type "text/html"
        <<-EOS
<body onload='document.forms[0].submit()'>
  <form action="http://localhost:9292" method='post'>
    <input type='hidden' name='token'   value='this-is-a-token'>
    <input type='hidden' name='user'    value="{'id':'user_id','provider':'github'}">
    <input type='hidden' name='storage' value='localStorage'>
  </form>
</body>
        EOS
      end

      get "/auth/:provider/callback/iframe" do
        content_type "text/html"
        <<-EOS
<script>
function tellEveryone(msg, win) {
  if(win == undefined) win = window;
  win.postMessage(msg, '*');
  if(win.parent != win) tellEveryone(msg, win.parent);
  if(win.opener) tellEveryone(msg, win.opener);
}

function uberParent(win) {
  return win.parent === win ? win : uberParent(win.parent);
}

function sendPayload(win) {
  var payload = {
    'user': 'this will be the user',
    'token': 'this will be the token'
  };
  uberParent(win).postMessage(payload, 'http://localhost:9293/');
}

if(window.parent == window) {
  sendPayload(window.opener);
  window.close();
} else {
  tellEveryone('done');
  sendPayload(window.parent);
}
</script>
        EOS
      end

      desc "Authentication callback."
      get "/auth/:provider/callback" do
        auth = env['omniauth.auth']
        user = Tribute::Models::User.where(provider: auth[:provider], uid: auth[:uid]).first_or_initialize
        warden.set_user user
        content_type "text/html"
        # redirect request.env['omniauth.params']['redirect_uri']
        <<-EOS
<!DOCTYPE html>
<html><body><script>
// === THE FLOW ===

// every serious program has a main function
function main() {
  doYouHave(thirdPartyCookies,
    yesIndeed("third party cookies enabled, creating iframe",
      doYouHave(iframe(after(5)),
        yesIndeed("iframe succeeded", done),
        nopeSorry("iframe taking too long, creating pop-up",
          doYouHave(popup(after(5)),
            yesIndeed("pop-up succeeded", done),
            nopeSorry("pop-up failed, redirecting", redirect))))),
    nopeSorry("third party cookies disabled, creating pop-up",
      doYouHave(popup(after(8)),
        yesIndeed("popup succeeded", done),
        nopeSorry("popup failed", redirect))))();
}

// === THE LOGIC ===
var url = window.location.pathname + '/iframe' + window.location.search;

function thirdPartyCookies(yes, no) {
  window.cookiesCheckCallback = function(enabled) { enabled ? yes() : no() };
  var img      = document.createElement('img');
  img.src      = "https://third-party-cookies.herokuapp.com/set";
  img.onload   = function() {
    var script = document.createElement('script');
    script.src = "https://third-party-cookies.herokuapp.com/check";
    window.document.body.appendChild(script);
  }
}

function iframe(time) {
  return function(yes, no) {
    var iframe = document.createElement('iframe');
    iframe.src = url;
    timeout(time, yes, no);
    window.document.body.appendChild(iframe);
  }
}

function popup(time) {
  return function(yes, no) {
    if(popupWindow) {
      timeout(time, yes, function() {
        if(popupWindow.closed || popupWindow.innerHeight < 1) {
          no()
        } else {
          try {
            popupWindow.focus();
            popupWindow.resizeTo(900, 500);
          } catch(err) {
            no()
          }
        }
      });
    } else {
      no()
    }
  }
}

function done() {
  if(popupWindow && !popupWindow.closed) popupWindow.close();
}

function redirect() {
  tellEveryone('redirect');
}

function createPopup() {
  if(!popupWindow) popupWindow = window.open(url, 'Signing in...', 'height=50,width=50');
}

// === THE PLUMBING ===
function tellEveryone(msg, win) {
  if(win == undefined) win = window;
  win.postMessage(msg, '*');
  if(win.parent != win) tellEveryone(msg, win.parent);
  if(win.opener) tellEveryone(msg, win.opener);
}

function timeout(time, yes, no) {
  var timeout = setTimeout(no, time);
  onSuccess(function() {
    clearTimeout(timeout);
    yes()
  });
}

function onSuccess(callback) {
  succeeded ? callback() : callbacks.push(callback)
}

function doYouHave(feature, yes, no) {
  return function() { feature(yes, no) };
}

function yesIndeed(msg, callback) {
  return function() {
    if(console && console.log) console.log(msg);
    return callback();
  }
}

function after(value) {
  return value*1000;
}

var nopeSorry = yesIndeed;
var timeoutes = [];
var callbacks = [];
var seconds   = 1000;
var succeeded = false;
var popupWindow;

window.addEventListener("message", function(event) {
  if(event.data === "done") {
    succeeded = true
    for(var i = 0; i < callbacks.length; i++) {
      (callbacks[i])();
    }
  }
});

// === READY? GO! ===
main();
</script>
</body>
</html>
        EOS
      end

      desc "Authentication failure callback."
      get "/auth/failure" do
        error! "Unauthorized (Omniauth)", 401
      end

    end
  end
end

