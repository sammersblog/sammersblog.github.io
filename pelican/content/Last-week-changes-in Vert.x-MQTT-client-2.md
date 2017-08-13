Title: Last week changes in Vert.x MQTT client #2
Date: 30 July 2017
Category: GSoC
	
# Intro
This post is dedicated to changes in Vert.x MQTT client which was made in the last week. 

Here it is the short list of topic I will talk about:

* Vert.x MQTT client and server in the same repository

* Opportunity to config max message size

* Handler for closing connection and internal netty's exceptions

# Vert.x MQTT client and server in the same repository

Approximately one and half month ago we had been working on an initial version of Vert.x MQTT client and there is was one little problem: there are some classes that can be used by server and client so that they should be shared, but they weren't. After a discussion on [Vert.x google group](https://groups.google.com/forum/#!topic/vertx-dev/34-kHI5a4EY) we have decided to move Vert.x MQTT client sources to Vert.x MQTT server repository. Actually, since then both of client and server located in one artifact. Thus you can find repository with client and server source [here](https://github.com/vert-x3/vertx-mqtt).

# Opportunity to config max message size

Before this change client was able to receive only messages with size up 8096 bytes. According to [this improvement](https://github.com/vert-x3/vertx-mqtt/pull/38), a user can configure the client to allow messages of any size by passing specific option.

# Handler for closing connection and internal netty's exceptions

When communicating with a server the connection can be closed without sending related packet. [Now](https://github.com/vert-x3/vertx-mqtt/pull/40), you can subscribe for such event just providing a handler:

```java
client.closeHandler(v -> {
  // connection is closed
  // do something....
});
```

Also, Vert.x is based on Netty and some error in its internal structures can be the cause of application crush. [The next improvement](https://github.com/vert-x3/vertx-mqtt/pull/41) is about catching such things. Exceptions can be caught in a way like this:

```java
client.exceptionHandler(e -> {
  // exception handling logic here
});
```

Thanks for reading!

Cheers!