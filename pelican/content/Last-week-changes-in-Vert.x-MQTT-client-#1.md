Title: Last week changes in Vert.x MQTT client #1
Date: 14 July 2017
Category: GSoC

In this post i will just inform you about things happened last week in Vert.x MQTT client.

First thing is about changes in internal structure of MQTT client. The client itself based on [NetClient](link) and any changes in NetClient will cause the similar ones in MQTT client. So last chages was about making it able to handle arbitrary messages and exposing less details to API consumer. As a result, MQTT client was [refactored] and now it use new API. 

Here a changes in Vert.x core is:

https://github.com/eclipse/vert.x/pull/2044
https://github.com/eclipse/vert.x/commit/586be5c626aececc1d7bb403a37e2851485d205e

Changes in Vert.x MQTT client:

https://github.com/vert-x3/vertx-mqtt-client/pull/14

Changes in Vert.x MQTT server:

https://github.com/vert-x3/vertx-mqtt-server/pull/29

Another thing is connected with topic validation when sending [PUBLISH](http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/csprd02/mqtt-v3.1.1-csprd02.html#_Toc385349773) or [SUBSCRIBE](http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/csprd02/mqtt-v3.1.1-csprd02.html#_Toc385349799) MQTT packet. Basically, the single and multi-level wildcard characters MUST NOT be used within a Topic Name (when sending [PUBLISH](http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/csprd02/mqtt-v3.1.1-csprd02.html#_Toc385349773)). Additionally, Topic Name should not contain null character (Unicode U+0000). 

So, it is a pretty simple to validate Topic Name, but what about Topic Filter (when sending [SUBSCRIBE](http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/csprd02/mqtt-v3.1.1-csprd02.html#_Toc385349799))? Clearly, It's a little more complicated. Topic Filter can contains all of wildcards, so like: "+", "/", "#". But they can be used in specific way.

Quick explanation:

* (‘/’ U+002F) is used to separate each level within a topic tree and provide a hierarchical structure to the Topic Names.
* (‘#’ U+0023) is a wildcard character that matches any number of levels within a topic.
* (‘+’ U+002B) is a wildcard character that matches only one topic level

Some examples of wrong and right usages:

* “sport/tennis/#” is valid
* “sport/tennis/#/ranking” is not valid
* “sport/+/player1” is valid  
* “sport+” is not valid

More about Topic Names and Topic Filters in exaples and explanations can be found in MQTT 3.1.1 spec:

http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/csprd02/mqtt-v3.1.1-csprd02.html#_Toc385349843

Github PR for that:

https://github.com/vert-x3/vertx-mqtt-client/pull/13

The last, but not least one for today is handling QoS=1 and 2 PUBLISH messages. Here the schema of PUBLISH pipline:

![image](https://user-images.githubusercontent.com/16746106/28056736-a4794072-6626-11e7-9eb6-483a4c049897.png)  

So the PR for that was created 14 days ago and since then it was rewrited 3 times. The main complexity is that handling of inbound and outbound messages should be lightweight enought. It was not so when i had been implemented that second time. It was based on Vert.x timers. So it is a predictable that with growing amount of publish sessions the client's verticle will just handle a lot of timers without doing anything else.

A current implementaion of the issue is approach called "in flight queue". This approach takes advantage of message ordering granted by MQTT 3.1.1 protocol.

More about message ordering:

http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/csprd02/mqtt-v3.1.1-csprd02.html#_Toc385349841

Github PR for that:

https://github.com/vert-x3/vertx-mqtt-client/pull/8

Than you for reading my blog.

Cheers!



