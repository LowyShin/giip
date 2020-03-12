Service Page : http://giipasp.azurewebsites.net

Documentation : 
  * English : https://github.com/LowyShin/giip/wiki
  * Japanses : https://github.com/LowyShin/giipdoc-ja/wiki
  * Korean : https://github.com/LowyShin/giipdoc-ko/wiki

***

We launched GIIP token!!

Token exchanges : https://tokenjar.io/GIIP

Token sales information : https://www.slideshare.net/LowyShin/giipentokenjario-giip-token-trade-manual-20190416-141149519

![giip Token Economy][giiptokeneconomy]

# Introduce

Customer want server works and development as DevOps, etc. but then want waste money.

SIer want get more money from customer for server works, and development, etc.

How can reduce their gap?

We think GIIP token for it!

Customer pay their budget. 
And worker can get their pair work revenue by GIIP token.

If worker need money as soon as possible, then worker sales GIIP token to market cheaper.
If worker does not need money soon, then worker sales GIIP token good price position on market.

It is any work can fit this ecosystem.
But we starting on RPA territory. because RPA is best fittable on GIIP ecosystem.

# giip

giip is RPA engine that human works transform to AI. 

We opened wiki in github to share knowledge and scripts for giip.

Wiki in English : https://github.com/LowyShin/giip/wiki (giip related operation scripts can be found here)

Wiki in Japanese: https://github.com/LowyShin/giipdoc-ja/wiki

## Overview

How do we design to fully automate operation on all kinds of devices in the world (i.e. Robots, Drones, IoT devices, Server, PC, Mobile device)?

We look at DevOps systems from developers’ point of view as most of them are planned and developed by developers. Because of that, even though we develop system operation tools with DevOps, they can’t cover huge system. We have to do some in manual way or do sharding. Then, what would be the system like if system architecture designs DevOps? 


Here is the operation system architecture that has been continuously improved since 2007 while operating large scale system like financial system in SFI(SONY Finance International), system operation for massive multiplayer online games and fight with crackers in Nexon, network management for service that has more than 300Gbps instant traffic like LoL(League of Legends), ISP network operation as big as backbone of country, and big cloud services operation.

That's why born of giip engine.

Below is our philosophy for the engine that we has continuously built and updated for more than 10 years. 

## KVS (Key Value Store)

KVS concept is implemented to collect data from any system, and to use unstructured data type JSON like database. Most of system operators have experience of struggling to match data format or use different tools, and probably struggling at the moment as well.
It is the first operation system that you can manage intuitively, that displays data to screen as if you see it from server, even if the data is in a different format from different OS (Linux, Windows, Mac OS, HP-UX, AIX, Solaris, etc).

![giip KVS:Key value store][Trigger Graph]

## MSA (Microservice Architecture)

All functionality can be separated, or removed. It is designed completely based on MSA, so it is easy to apply new technology, and function failure would not lead to service failure. You can extract some of functionality from giip and use it for other system. It’s also possible to create a new service by connecting some giip functionality. 

![alt text][giipArchitecture]

## MVC (Model View Controller)

There are source code classification algorithms like MVC or MVP. In giip we have original MVC. With other development framework’s MVC, we had to choose View, Model, and Controllers all based on the framework. However with giip we can put each Model or View with totally different framework together. You can use giip as a new service by purchasing Bootstrap theme, copying and customizing API. You can use as RDBMS. It is also easy to utilize with NoSQL.

## Scale out ＆ Redundancy

Some developers think that integrated source management is an old way. However Amazon and GREE, that runs more than 10,000 servers, deploy integrated source to many servers, and enable only necessary functionality among them. By doing that, we can deploy clients to hundreds of servers, and we can enable API functionality on other 1/3 servers, that are used for other purpose and still have capacity, so we can scale out and implement redundancy.

## GLB (Global Load Balancer)

Load balance can be implemented to all resources in all over the world like servers in various geographical locations (U.S.A or Europe) by using GLB(Someone calls GSLB). New scalability and distribution concept has been applied that could not be done with existing L4 like DSR.

## RPA (Robotics Process Automation)

giip engine was designed in 2007 based on experience on automated operation system. i.e. HITACHI JobNet, JP1, Senju, BMC Control-M, and so on.
We have base structure that is designed for perfect RPA as human. It is totally different from other products that forcefully add RPA feature to existing solutions. Human like mouse movement and screen recognition as it is controlled by utilizing many user input tools like Autohotkey, Selenium, and Jmeter to implement real user actions.

![giip AI management][giip-concept-AISE]

## CQE(Command Queue Engine)

CQE defines what jobs clients do, and manages execution according to conditions. It is giip original engine that is designed to manage jobs for many different scenarios, like checking specific server failure via mobile device, sending commands to which laptop to handle, having the laptop remotely control the server, or which media to save regular backups after local compression and sending them to networks.

## MQE(Message Queue Engine)

It is giip original message queue engine that resolved MQTT’s weakness. It exchanges data with JSON method. Even if there are many things to process, because it follows FIFO, even when using like RDBMS cache it can process fast like Async method. Also a client with network authorization (for example via Secret Key) can receive information and makes a decision or reports. It is easy to make graphs or statistics using KVS. If it is difficult to compile statistics with JSON data format because of format issue, it can parse JSON data regularly to change format that works better with graphs. It is easier to create dashboards or reports by integrating data with graph tool based on JSON data like Morris.js, jqplot. 

![giip Message Queue Engine][giipMessageQueue]

## Open source

It is made with MSA structure, so it can be connected with many open sources like Openstack, kubernetes, Node.js, Bootstrap, ELK(Elastic Logstash Kibana), and EFK(Elastic Fluentbit, Kibana). When using open sources you can exclude some features that are already in giip. Inversely, you can extract some of giip features and use open sources as base.

See also, https://www.slideshare.net/LowyShin/giip-engine-open-source-revolution

## MarketPlace

You can create scripts with your system operation knowhow and sell them. 
If a simple backup script is 0.01USD per execution, and if customer execute once a day it would be 0.3USD per month. There are tools that are normally difficult to install/set up like MongoDB, or Hadoop, but you can easily install to your serves by selecting it from market place and deploying. You don’t need all knowledge but need only knowledge that helps your business, then for rest of it you can request other people who have experience with low price. The most suitable system operation tools for global business will be provided. For system engineers, you used to be paid for hours that you worked, but now once you upload your knowhow you can create unlimited value.

Marketplace : http://giipweb.littleworld.net/view/SMAHTML/MPScriptList.asp

## MLE(Machine Learning Engine)

For machine learning functionality we still use CQE and MQE, but we have been improving marketplace while considering structure that connects GPU resources provider, machine learning algorithm provider, and recourses consumers. Since it is designed based on MSA completely, it is taking time. However, sensitive data like life insurance, app data, or stock related data process is being customized on giip engine. With these knowhow, market place will be evolved and connect resources, knowledge, and clients.

## Is giip for me?

Now saying real examples.

We have a client who is using AWS(Amazon Web Service). Development server and VMs which installed giip Agent were in internal local IP environment. Giip can still do integrated management in this environment. One day, we received CS call from this client. The client could not connect to server with ssh from anywhere, because the client applied iptables to AWS VM without IP address for remote connection by mistake. AWS replied to the client that they need to create new VM. However fortunately giip agent was running, we could send remote command “service iptables stop (systemctl stop firewalld on CentOS7)”. The client was finally able to connect.

As you can see, there are many things that cannot be done with basic tools provided by cloud service providers. Also in many situations, it can be used within the rule defined by the providers. Furthermore, you cannot manage internal development server together which has local IP address. There is no tool for domain based service like Azure as IP address is changed frequently. We had experienced difficulty in many operation environments. That’s why we could build giip to do integrated management in these environments.

Many of CSB(Cloud Service Brokerage), CMP(Cloud Management Platform) services just connect each cloud providers’ API. People who really run systems do not use these. These are just to show, and created by people who do not have experience on system operation. What is important is not just creating VM. The most important thing is whether the service on VM or PM is running properly or not.

One user said that giip has a charm that he simply cannot stop using it. You can also recreate UI and manage only with API as if it is your personalized tool. Would you like to try giip? 


## Looking for Partners 

We are looking for individuals or companies who would like to improve giip together! Please contact us. We can share environment and source.
It is free if you create scripts by yourself to operate for your system. Plus, if you standardize scripts and upload to market place, you can earn money. Are you creating scripts? We can work together and share your experience with the whole world.
 

Please contact giip for any inquiry, partner, or advertisement.

[Contact Us](https://github.com/LowyShin/giip/wiki/Contact-Us)


## Token Sales

Token exchanges : https://tokenjar.io/GIIP

Token sales information : https://www.slideshare.net/LowyShin/giipentokenjario-giip-token-trade-manual-20190416-141149519

1 gas = 0.0005 GIIP

For token purchase, collaboration, token development (ERC20, ERC721, etc)

[Contact Us](https://github.com/LowyShin/giip/wiki/Contact-Us)



[giiptokeneconomy]: https://github.com/LowyShin/giip/blob/gh-pages/images/PP/GIIP%20Token%20economy.png "giiptokeneconomy"
[giip-concept-AISE]: https://github.com/LowyShin/giip/blob/gh-pages/images/PP/giip-PP-Intro-AISE02.png "giip-concept-AISE"
[giip-concept]: https://github.com/LowyShin/giip/blob/gh-pages/images/ss/giip_intro02.png "giip-concept"
[giip-intro-position]: https://github.com/LowyShin/giip/blob/gh-pages/images/ss/giip_position1607.png "giip-intro-position"
[giipCompetition]: https://github.com/LowyShin/giip/blob/gh-pages/images/giip-competition.jpg "giip Competition"
[giipMessageQueue]: https://github.com/LowyShin/giip/blob/gh-pages/images/giip-MessageQueArchitecture.jpg "giip Message Queue"
[Trigger Graph]: https://github.com/LowyShin/giip/blob/gh-pages/images/ss/giip-SS-TriggerAdd01-Graph.png "giip Trigger Graph"
[giipArchitecture]: https://github.com/LowyShin/giip/blob/gh-pages/images/ss/giip_architecture_1607.png "giip Architecture"
[Logical Server Detail]: https://github.com/LowyShin/giip/blob/gh-pages/images/ss/giip-SS-LogicalServerDetail.png "Logical Server Detail"
