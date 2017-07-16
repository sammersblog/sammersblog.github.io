Title: Last week changes in Vert.x MQTT client #1
Date: 16 July 2017
Category: GSoC

## Intro

In this post, I will just inform you about things happened last week in Vert.x MQTT client.

# New NetClient API

First thing is about changes in the internal structure of MQTT client. The client itself based on NetClient and any changes in NetClient will cause the similar ones in MQTT client. So, last changes were about making it able to handle arbitrary messages, and exposing fewer details to API consumers. As a result, MQTT client was refactored and now it uses new API.

##### Here changes in Vert.x core is:

[https://github.com/eclipse/vert.x/pull/2044](https://github.com/eclipse/vert.x/pull/2044) [https://github.com/eclipse/vert.x/commit/586be5c626aececc1d7bb403a37e2851485d205e](https://github.com/eclipse/vert.x/commit/586be5c626aececc1d7bb403a37e2851485d205e)

##### Changes in Vert.x MQTT client:

[https://github.com/vert-x3/vertx-mqtt-client/pull/14](https://github.com/vert-x3/vertx-mqtt-client/pull/14)

##### Changes in Vert.x MQTT server:

[https://github.com/vert-x3/vertx-mqtt-server/pull/29](https://github.com/vert-x3/vertx-mqtt-server/pull/29)

# Topic Names and Topic Filters validation
Another thing connected with topic validation when sending [PUBLISH](http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/csprd02/mqtt-v3.1.1-csprd02.html#_Toc385349773) or [SUBSCRIBE](http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/csprd02/mqtt-v3.1.1-csprd02.html#_Toc385349799) MQTT packet. Basically, the single and multi-level wildcard characters MUST NOT be used within a Topic Name (when sending [PUBLISH](http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/csprd02/mqtt-v3.1.1-csprd02.html#_Toc385349773)). Additionally, Topic Name should not contain null character (Unicode U+0000).

So, it is a pretty simple to validate Topic Name, but what about Topic Filter (when sending [SUBSCRIBE](http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/csprd02/mqtt-v3.1.1-csprd02.html#_Toc385349799)? Clearly, It's a little more complicated. Topic Filter can contains all of wildcards, so like: "+", "/", "#". But they can be used in a specific way.

##### Quick explanation:

* *(‘/’ U+002F) is used to separate each level within a topic tree and provide a hierarchical structure to the Topic Names.*
* *(‘#’ U+0023) is a wildcard character that matches any number of levels within a topic.*
* *(‘+’ U+002B) is a wildcard character that matches only one topic level*

##### Some examples of wrong and right usages:

* *“sport/tennis/#” is valid*
* *“sport/tennis/#/ranking” is not valid*
* *“sport/+/player1” is valid*
* *“sport+” is not valid*

##### More about Topic Names and Topic Filters in examples and explanations can be found in MQTT 3.1.1 spec:

[Topic Names and Topic Filters](http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/csprd02/mqtt-v3.1.1-csprd02.html#_Toc385349843)

##### Github PR for that:

[https://github.com/vert-x3/vertx-mqtt-client/pull/13](https://github.com/vert-x3/vertx-mqtt-client/pull/13)


# Handling QoS=1 and QoS=2 PUBLISH messages.
The last, but not least one for today is handling QoS=1 and 2 PUBLISH messages. Here the schema of PUBLISH pipeline is:

![image](https://user-images.githubusercontent.com/16746106/28243056-893190be-69c6-11e7-95ea-556aea29a634.png)

So, the PR for that was created 14 days ago and since then, it was rewritten 3 times. The main complexity is that handling of inbound and outbound messages should be lightweight enough. It was not so when I had been implemented that second time. It was based on Vert.x timers. So, it is predictable that with growing amount of publishing sessions the client's verticle will just handle a lot of times without doing anything else.

A current implementation of the issue used approach called "in flight queue". This approach takes advantage of message ordering granted by MQTT 3.1.1 protocol.

##### More about message ordering:

[Message ordering](http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/csprd02/mqtt-v3.1.1-csprd02.html#_Toc385349841)

##### Github PR for that:

[https://github.com/vert-x3/vertx-mqtt-client/pull/8](https://github.com/vert-x3/vertx-mqtt-client/pull/8)

Thank you for reading my blog.

Cheers!