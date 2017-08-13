Title: Last week changes in Vert.x MQTT client #3
Date: 13 Aug 2017
Category: GSoC


# Intro

Welcome! Today I going to introduce you to the things that happened with Vert.x MQTT client last week.

# Vert.x 3.5.0.Beta1 release

The great thing about Vert.x MQTT client is that it has been released and now available in maven central. Don't know the right way to start? Read [this](https://sammersblog.github.io/how-i-can-use-vertx-mqtt-cleint.html).

# Mqtt-client examples

You most probably aware of [vertx-exampeles](https://github.com/vert-x3/vertx-examples) project. I have contributed some examples of Vert.x MQTT client usage and put them together with server ones. So, you can find these examples in [related branch](https://github.com/vert-x3/vertx-examples/tree/3.5.0.beta1/mqtt-examples). [PR for that](https://github.com/vert-x3/vertx-examples/pull/220).

# Situation when receiving another CONNECT packet

Github is very good place for open source. One day, someone just submitted [an issue](https://github.com/vert-x3/vertx-mqtt/issues/33) and anyone can work on a solution. Same thing was in my case. After a quick discussion, i figured out the cause of the problem and then proposed a [PR for that](https://github.com/vert-x3/vertx-mqtt/pull/43).

# SSL support & Wireshark

To be sure that some feature works you should write a couple of unit tests. In [the PR](https://github.com/vert-x3/vertx-mqtt/pull/44) I proposed some tests to make sure that Vert.x MQTT client can communicate with remote MQTT servers via SSL and it works fine. Another way to check the SSL/TLS handshake is to take a look at network traffic, and [Wireshark](https://www.wireshark.org/) is a great tool for that. Here is how it looks like in [Wireshark](https://www.wireshark.org/):

![image](https://user-images.githubusercontent.com/16746106/29253281-198b6a6a-8081-11e7-9d9b-9b8027eac176.png)

That is all for today!

Cheers!
