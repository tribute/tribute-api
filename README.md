Tribute API
===========

[![Build Status](https://secure.travis-ci.org/tribute/tribute-api.png)](http://travis-ci.org/tribute/tribute-api)

Run
---

```
bundle install
rackup
```

Session Cookie Secret
---------------------

For production, set `ENV['SESSION_COOKIE_SECRET']` to something permanent generated with `SecureRandom.base64`.

Github Authentication
---------------------

Register an application on Github, at https://github.com/settings/applications. 

* Main url: *http://localhost:9292*
* Callback url: *http://localhost:9292/auth/github/callback*

```
GITHUB_KEY=... GITHUB_SECRET=... rackup
```

Try http://localhost:9292/auth/github.

New Relic
---------

The application is setup with NewRelic w/ Developer Mode. Navigate to http://localhost:9292/newrelic after making some API calls.
