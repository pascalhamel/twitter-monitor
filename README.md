## Twitter Monitor
The Twitter Monitor is a simple Rails daemon that uses the Twitter Stream API to listen to tweets sent to a specific account.
Actions are then performed to an API depending on the content of the tweet.

There is also an API used to register users to the daemon in order to match their Twitter accounts to the APIs on which
actions are performed.

## Supported APIs
* [Crowdbase](https://api.crowdbase.com)

## How to install
### 1. Clone the repository.

### 2. Configure a Twitter account.

You can either fill the *config/twitter.yml* file or set the following environment variables:
```sh
TWITTER_CONSUMER_KEY
TWITTER_CONSUMER_SECRET
TWITTER_OAUTH_TOKEN
TWITTER_OAUTH_TOKEN_SECRET
```

### 3. Configure an API.

The only supported API right now is Crowdbase. You can either fill the *lib/twitter_monitor/apis/crowdbase_wrapper/config/config.yml* file
or set the following environment variables:
```sh
CROWDBASE_CLIENT_ID
CROWDBASE_CLIENT_SECRET
```

### 4. Create the database and the tables.

Create a database, fill the database.yml file and run:
```sh
rake db:migrate
```

### 5. Start the daemon and the Rails server.

To start the daemon, simply run this rake task and specify the correct API:
```sh
rake monitor_twitter api=crowdbase
```

## How to use for Crowdbase
### 1. Hook your Twitter account with your Crowdbase account.
Make a call to the Twitter Monitor API to hook a Twitter account and a Crowdbase account:
```sh
curl --data "twitter_user_id=123456789&username=user@user.com&password=PASSWORD&subdomain=crowdbase_subdomain" http://YOUR_SERVER/api/v1/crowdbase_users.json
```

### 2. Send tweets to the monitoring account.
There are three possible actions :

**Post a note:** Send a tweet to @YOUR_MONITORING_ACCOUNT that does not end with an interrogation point and contains no link.
```sh
@YOUR_MONITORING_ACCOUNT This will post a note to Crowdbase in section #topic.
```

**Post a question:** Send a tweet to @YOUR_MONITORING_ACCOUNT that ends with an interrogation point but contains no link.
```sh
@YOUR_MONITORING_ACCOUNT This will ask a question in Crowdbase in section #topic?
```

**Post a link:** Send a tweet to @YOUR_MONITORING_ACCOUNT with one or more links.
```sh
@YOUR_MONITORING_ACCOUNT This will post a link to Crowdbase in section #topic http://www.crowdbase.com
```

In any case, the daemon tries to match hashtags with existing topics and associates the post with the first one found.