# Steps to create a pod with SSL termination

1. Generate self signed certs
2. Configure container to use SSL
3. Mount certs to the container

For the purpose of this example, I will be using nginx containers.
I also want to use SSL for traffic that will not be using a URL so I'll be generating self signed certs
I'll be referencing this [post from Digital Ocean](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-on-centos-7) for a few of these steps.

For easy cleanup, we'll create all the resources in a new namespace:

`kubectl create ns ssl-test`

## Generate self signed certs

We'll use openssl to generate the certs. For now, we don't need to worry about where the keys are being output to since we'll be converting them to a secret for use in the pod.

`openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout selfsigned.key -out selfsigned.crt`

Now create a secret using these two files

`kubectl create -n ssl-test secret tls ssl-certs --key selfsigned.key --cert selfsigned.crt`

## Configure the container for SSL

Nginx requires a `server block` to enable SSL. If you are using a different webserver or framework, the steps to enable SSL will be different
I used the server block from the Digital Ocean walkthrough and converted it to a configMap using the --from-file flag
Notice that the nginx config requires the server IP address, there is no way to predict the pod IP so instead I am using a variable for the name ($IPADDRESS) which will be created in the pod template using the [downward API](https://kubernetes.io/docs/tasks/inject-data-application/environment-variable-expose-pod-information/),
Nginx conf files do not support environment variables, so the configMap will create a template which will be used to convert the variable inot the host IP and push to the ssl.conf.

## Mount the secret into the container

Next we just need to mount the certs into the container by mounting the secret
Make sure to set the mountPath of the secret to match the paths defined in the `server block`

View the `ssl-nginx.yaml` file to see a completed example along with the internal load balancer service

## Clean up

To clean up, delete the namespace were the test resources were created

> kubectl delete ns ssl-test
