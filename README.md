# Platform Engineer Challenge

## Description
This project is part of an recruitment challenge where the objective is to create a dockerized deployment of a sample web app using Tomcat. The challenge specifically requires enabling SSL/TLS on Tomcat in an automated manner.

## Requirements
-  Docker must expose port 4041;
- Tomcat version used is 8.5;
- Base docker image is 'centos:7';
- No manual commands should be necessary after running the Docker container to start and make the sample app available;
- SSL/TLS must be enabled on the Tomcat daemon at port 4041.

## How to use

1. Clone the Repository;
2. Build the Docker Image: Execute "**docker build -t challenge .**" ;
3. Run the Docker Container: Execute "**docker run -p 4041:4041 challenge**" ;
4. Access the Sample App: Open a web browser and go to https://localhost:4041/sample

## PEM files

**SSL/TLS** is essential for ensuring secure communication between the client (browser) and server (Tomcat) through encryption. To configure SSL/TLS in Tomcat, you need a digital certificate and an associated private key. Here's the purpose of each:
- **Certificate (server.crt)**: Serves to verify the server's identity. It contains information such as the domain name (Common Name - CN), the state, the country and the server's public key;
- **Private Key (server.key)**: The private key is generated along with the certificate and must be kept confidential by the server. It allows the server to decrypt encrypted messages received from clients.

I used this command to generate the private key along with the certificate:
```cmd
openssl req -newkey rsa:2048 -nodes -keyout server.key -x509 -days 365 -out server.crt -subj "/C=PT/ST=Lisbon/L=Lisbon/O=Challenge/OU=Challenge/CN=localhost"
```
## PKCS12

**PKCS12** is a widely recognized standard for storing or transporting a digital certificate along with its private key and optionally certificate chains. 
By integrating the **certificate** (server.crt) and **private key** (server.key) into a PKCS12 keystore file, we ensure a robust and standardized setup for SSL/TLS in the Dockerized Tomcat environment, as required by the  challenge.