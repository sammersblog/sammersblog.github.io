Title: How I can use Vert.x MQTT cleint?
Date: 23 July 2017
Category: GSoC

The thing I would like to tell you about in this article is set upping Vert.x MQTT client. Actually, I have a [real example](https://github.com/Sammers21/vertx-mqtt-client-example) so you can try it quickly.

If you are using Maven or Gradle, add the following dependency to the dependencies section of your project descriptor to access the Vert.x MQTT client:

* Maven (in your pom.xml):

```xml
<dependency>
    <groupId>io.vertx</groupId>
    <artifactId>vertx-mqtt-client</artifactId>
    <version>3.5.0-SNAPSHOT</version>
</dependency>
```

* Gradle (in your build.gradle file):

```groovy
dependencies {
  compile 'io.vertx:vertx-core:3.4.2'
}
```

The Vert.x MQTT client will be released on 04 August with Vert.x 3.5.0 release, so artifact can be downloaded from Maven central for now and you should install artifact locally. To do so execute this:

```bash
git clone https://github.com/Sammers21/vertx-mqtt-client
cd vertx-mqtt-client
mvn clean install
```

Now that you’ve set up your project, you can create a simple application which will receive all messages from all broker channels:

```java

import io.vertx.core.AbstractVerticle;
import io.vertx.mqtt.MqttClient;
import io.vertx.mqtt.MqttClientOptions;

import java.io.UnsupportedEncodingException;

public class MainVerticle extends AbstractVerticle {

  @Override
  public void start() {
    MqttClientOptions options = new MqttClientOptions()
      // specify broker host
      .setHost("iot.eclipse.org");

    MqttClient client = MqttClient.create(vertx, options);

    client.publishHandler(s -> {
      try {
        String message = new String(s.payload().getBytes(), "UTF-8");
        System.out.println(String.format("Receive message with content: \"%s\" from topic \"%s\"", message, s.topicName()));
      } catch (UnsupportedEncodingException e) {
        e.printStackTrace();
      }
    });

    client.connect(s -> {
      // subscribe to all subtopics
      client.subscribe("#", 0);
    });
  }
}
```

The **publishHandler** is the handler called each time the broker, located at iot.eclipse.org:1883, send a message to you, from the topics you subscribing for.

But just providing a handler is not enough, you should also connect to the broker and subscribe to some topics. For this reason, you should use a **connect** method and then call **subscribe** when connection established. 

To deploy this verticle form typical application you should have in your **main** method something like that:

```java
Vertx vertx = Vertx.vertx();
vertx.deployVerticle(MainVerticle.class.getCanonicalName());
```

If you have completed all steps correctly the result should look like that:

![](http://i.imgur.com/b4yYQJE.gif)

As the alternative and recommended way to bootstrap Vert.x applications you can use [vertx-maven-starter](https://github.com/vert-x3/vertx-maven-starter) of [vertx-gradle-starter](https://github.com/vert-x3/vertx-gradle-starter). For completing this guide I have used the first one. The final source code available [here](https://github.com/Sammers21/vertx-mqtt-client-example). If you would like to learn more about Vert.x MQTT client API then check out the [full documentation](https://github.com/vert-x3/vertx-mqtt-client/blob/initial-work/src/main/asciidoc/java/index.adoc). 

Thank you for reading my blog!

Cheers!