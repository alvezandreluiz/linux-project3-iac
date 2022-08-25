# linux-project3-iac
Docker: practical use in the microservices scenario

## Creating and running the Docker installation file

$ nano install-docker-ubuntu.sh<br />
$ chmod +x install-docker-ubuntu.sh<br />
$ ./install-docker-ubuntu.sh<br />

Useful Docker commands:

$ docker ps<br />
$ docker start mysql-A<br />
$ docker stop mysql-A<br />
$ docker rm mysql-A<br />
$ docker rm --force web-server<br />

## Starting a Docker Swarm cluster

On the main server (leader):<br />
$ docker swarm init

On the other servers (workers):<br />
$ docker swarm join --token SWMTKN-1-5w71uud62h8p4epo90ir2z5pu5ml5lhl95cp11djlqdrlich07-09ufwrbd1cti3trjrxpra93qf 172.31.95.210:2377

Command to view the nodes in the cluster:<br />
$ docker node ls

## Creating a container service on the cluster (replicas)

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

Mount the shared folder by the main server<br />
$ mount 172.31.95.210:/var/lib/docker/volumes/app/_data /var/lib/docker/volumes/app/_data

## Creating a proxy so that a request on one machine is replicated to all containers automatically, using NGINX

$ mkdir /proxy<br />
$ cd /proxy

Create or copy the nginx.conf and dockerfile files in the /proxy folder (the IP address of the servers 
in the nginx.conf file is the private IPv4 address)

$ nano nginx.conf<br />
$ nano dockerfile

Create a container with the nginx proxy configuration

root@aws-1:/proxy# docker build -t proxy-app .<br />
root@aws-1:/proxy# docker run --name my-proxy-app -dti -p 4500:4500 proxy-app

Command to view the containers in the cluster:<br />
$ docker container ls

## Testing the Cluster

Go to https://loader.io/, create an account if you don't have one.<br />
Create a target host with the IP address of the main server and port 4500 (http://3.88.85.142:4500, for example).<br />
Create a .txt file, with the name and content of the generated token, in the /var/lib/docker/volumes/app/_data 
folder on the main server.<br />
Go back to loader.io and verify that the "target" is working.<br />
Then create a test, including a name and the file index.php in the Client Requests path.<br />
Finally; run the test, check the result and see if there is a need to increase or decrease the number of servers and/or containers.

Enjoy your studies!


## Project Images

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

<figure>
    <figcaption>Inserting data into Clientes table using the file index.php via web browser</figcaption>
    <img src="./img/image8.png"
         alt="inserting data using the file index.php via web browser">
</figure>

<figure>
    <figcaption>Showing the data inserted into Clientes table via web browser</figcaption>
    <img src="./img/image9.png"
         alt="showing data inseted via web browser">
</figure>

<figure>
    <figcaption>Insert...</figcaption>
    <img src="./img/image10.png"
         alt="inserting data">
</figure>

<figure>
    <figcaption>Insert...</figcaption>
    <img src="./img/image11.png"
         alt="inserting data">
</figure>

<figure>
    <figcaption>Insert...</figcaption>
    <img src="./img/image12.png"
         alt="inserting data">
</figure>

<figure>
    <figcaption>Insert...</figcaption>
    <img src="./img/image13.png"
         alt="inserting data">
</figure>

<figure>
    <figcaption>Insert...</figcaption>
    <img src="./img/image14.png"
         alt="inserting data">
</figure>

<figure>
    <figcaption>Insert...</figcaption>
    <img src="./img/image15.png"
         alt="inserting data">
</figure>

<figure>
    <figcaption>Insert...</figcaption>
    <img src="./img/image16.png"
         alt="inserting data">
</figure>

<figure>
    <figcaption>Insert...</figcaption>
    <img src="./img/image17.png"
         alt="inserting data">
</figure>

<figure>
    <figcaption>Insert...</figcaption>
    <img src="./img/image18.png"
         alt="inserting data">
</figure>

<figure>
    <figcaption>Insert...</figcaption>
    <img src="./img/image19.png"
         alt="inserting data">
</figure>

<figure>
    <figcaption>Insert...</figcaption>
    <img src="./img/image20.png"
         alt="inserting data">
</figure>

<figure>
    <figcaption>Insert...</figcaption>
    <img src="./img/image21.png"
         alt="inserting data">
</figure>

<figure>
    <figcaption>Insert...</figcaption>
    <img src="./img/image22.png"
         alt="inserting data">
</figure>

<figure>
    <figcaption>Insert...</figcaption>
    <img src="./img/image23.png"
         alt="inserting data">
</figure>

<figure>
    <figcaption>Insert...</figcaption>
    <img src="./img/image24.png"
         alt="inserting data">
</figure>
