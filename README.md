# linux-project3-iac
Docker: practical use in the microservices scenario. Project part of Digital Innovation One's (DIO) Linux Experience Bootcamp.

## Creating and running the Docker installation file

Run the following commands on a Linux server (use the "install-docker-ubuntu.sh" file). I used an EC2 instance on AWS (aws-1).

$ nano install-docker-ubuntu.sh<br />
$ chmod +x install-docker-ubuntu.sh<br />
$ ./install-docker-ubuntu.sh<br />

<figure>
    <figcaption>EC2 instances created on AWS</figcaption>
    <img src="./img/image25.png"
         alt="Instances on AWS">
</figure>

<figure>
    <figcaption>Ports opened on servers</figcaption>
    <img src="./img/image24.png"
         alt="Ports opned">
</figure>

Useful Docker commands:

$ docker ps<br />
$ docker start mysql-A<br />
$ docker stop mysql-A<br />
$ docker rm mysql-A<br />

## Interacting with the created database

Establish a connection to the database (I used MySQL Workbench) and run the file "banco.sql" as a script.<br />
To do this you need to open port 3306 on the Linux server.

<figure>
    <figcaption>Database connection</figcaption>
    <img src="./img/image1.png"
         alt="Database connection">
</figure>

<figure>
    <figcaption>Creation of meubanco database</figcaption>
    <img src="./img/image2.png"
         alt="Creating database">
</figure>

<figure>
    <figcaption>Showing the databases</figcaption>
    <img src="./img/image3.png"
         alt="Displaying the databases">
</figure>

<figure>
    <figcaption>Creating Clientes table</figcaption>
    <img src="./img/image5.png"
         alt="Table Clientes">
</figure>

<figure>
    <figcaption>Showing meubanco tables</figcaption>
    <img src="./img/image4.png"
         alt="showing the database tables">
</figure>

<figure>
    <figcaption>Inserting data into Clientes table</figcaption>
    <img src="./img/image7.png"
         alt="inserting data">
</figure>

To insert data into the Clientes table from the web browser, create or copy the file "index.php" in the folder "/var/lib/docker/volumes/app/_data". Open port 80 on the server.

$ cd /var/lib/docker/volumes/app/_data<br />
root@aws-1:/var/lib/docker/volumes/app/_data# nano index.php

Add records to the database by accessing the IP address of the main server in the web browser.

<figure>
    <figcaption>Inserting data into Clientes table via web browser</figcaption>
    <img src="./img/image8.png"
         alt="inserting data via web browser">
</figure>

Every time you refresh the browser a new register is included into the database.

<figure>
    <figcaption>Showing the data inserted into Clientes table via web browser</figcaption>
    <img src="./img/image9.png"
         alt="showing data inserted via web browser">
</figure>

## Starting a Docker Swarm cluster

Open port 2377 on servers

On the main server (leader):<br />
$ docker swarm init

On the other servers (workers):<br />
$ docker swarm join --token SWMTKN-1-5w71uud62h8p4epo90ir2z5pu5ml5lhl95cp11djlqdrlich07-09ufwrbd1cti3trjrxpra93qf 172.31.95.210:2377

Command to view the nodes in the cluster:<br />
$ docker node ls

## Creating a container service on the cluster (replicas)

$ docker rm --force web-server<br />
$ docker service create --name web-server --replicas 10 -dt -p 80:80 --mount type=volume,src=app,dst=/app/ webdevops/php-apache:alpine-php7

Command to check the replicas in the cluster:<br />
$ docker service ps web-server

## Replicating a volume within the cluster

On the main server:<br />
$ apt-get install nfs-server

Adding a command line at the end of the file /etc/exports<br />
$ nano /etc/exports<br />
/var/lib/docker/volumes/app/_data *(rw,sync,subtree_check)

Exporting/Sharing the folder<br />
root@aws-1:/var/lib/docker/volumes/app/_data# exportfs -ar<br />
root@aws-1:/var/lib/docker/volumes/app/_data# showmount -e<br />
Command output:<br />
Export list for aws-1:<br />
/var/lib/docker/volumes/app/_data *

On the other servers:<br />
$ apt-get install nfs-common

Open port 2049 on servers<br />
Mount the shared folder by the main server<br />
$ mount 172.31.95.210:/var/lib/docker/volumes/app/_data /var/lib/docker/volumes/app/_data

<figure>
    <figcaption>Shared folder mounted on aws-3 server</figcaption>
    <img src="./img/image10.png"
         alt="Shared folder mounted on server 3">
</figure>

<figure>
    <figcaption>Shared folder mounted on aws-2 server</figcaption>
    <img src="./img/image11.png"
         alt="Shared folder mounted on server 2">
</figure>

## Creating a proxy so that a request on one machine is replicated to all containers automatically, using NGINX

$ mkdir /proxy<br />
$ cd /proxy

Create or copy the nginx.conf and dockerfile files in the /proxy folder (the IP address of the servers 
in the nginx.conf file is the private IPv4 address)

$ nano nginx.conf<br />
$ nano dockerfile

<figure>
    <figcaption>Creating proxy directory and the nginx.conf file</figcaption>
    <img src="./img/image12.png"
         alt="Creating proxy directory and nginx.conf file">
</figure>

<figure>
    <figcaption>Creating the dockerfile file</figcaption>
    <img src="./img/image13.png"
         alt="Creating dockerfile file">
</figure>

<figure>
    <figcaption>Showing the nginx.conf and dockerfile files created</figcaption>
    <img src="./img/image14.png"
         alt="Showing files created">
</figure>

Create a container with the nginx proxy configuration

root@aws-1:/proxy# docker build -t proxy-app .<br />
root@aws-1:/proxy# docker run --name my-proxy-app -dti -p 4500:4500 proxy-app

<figure>
    <figcaption>Installing the nginx proxy</figcaption>
    <img src="./img/image15.png"
         alt="Installing nginx proxy">
</figure>

<figure>
    <figcaption>Nginx proxy installed</figcaption>
    <img src="./img/image16.png"
         alt="Nginx installed">
</figure>

<figure>
    <figcaption>Creating the proxy container</figcaption>
    <img src="./img/image17.png"
         alt="Creating proxy container">
</figure>

Command to view the containers in the cluster:<br />
$ docker container ls

<figure>
    <figcaption>Showing the containers created</figcaption>
    <img src="./img/image18.png"
         alt="Containers created">
</figure>

## Testing the Cluster

Open port 4500 on servers<br />
Go to https://loader.io/, create an account if you don't have one.<br />
Create a target host with the IP address of the main server and port 4500 (http://3.88.85.142:4500, for example).<br />
Create a .txt file, with the name and content of the generated token, in the /var/lib/docker/volumes/app/_data 
folder on the main server.<br />

<figure>
    <figcaption>Txt file created with the generated token</figcaption>
    <img src="./img/image19.png"
         alt="Token file created">
</figure>

Go back to loader.io and verify that the "target" is working.<br />
Then create a test, including a name and the file index.php in the Client Requests path.<br />

<figure>
    <figcaption>Creating the test</figcaption>
    <img src="./img/image20.png"
         alt="Creating test">
</figure>

Finally; run the test, check the result and see if there is a need to increase or decrease the number of servers and/or containers.

<figure>
    <figcaption>Test 1 result</figcaption>
    <img src="./img/image21.png"
         alt="Test 1 result">
</figure>

<figure>
    <figcaption>Test 2 result</figcaption>
    <img src="./img/image22.png"
         alt="Test 2 result">
</figure>

<figure>
    <figcaption>Showing the database registers created by the test</figcaption>
    <img src="./img/image23.png"
         alt="Registers created by the test">
</figure>

Enjoy your studies!

Instructor: [Denilson Bonatti](https://www.linkedin.com/in/denilsonbonatti/)

<div align="right">
  <a href="#top">
    <img alt="Up" height="25" src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/svgs/solid/angle-up.svg">
  </a>
</div>
