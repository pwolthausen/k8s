# Workloads

1. How to deploy your application using a Deployment
2. Configure the container using Environment Variables
3. Add volumes
4. [Explore StatefulSet](https://cloud.google.com/kubernetes-engine/docs/concepts/statefulset)
5. Jobs Vs Deployments

## Using a Deployment

Using the basic deployment template (deployment.yaml), fill in the blank fields to deploy a basic database. To keep things simple, let's use the image for mysql from Docker Hub: ["mysql:5.7"](https://hub.docker.com/_/mysql).

## Setting Variables for the container

The MySQL database requires a root password which we will set through an environment variable. We can also set other variables such as a non root user, the non root user password and set a starting database.
Looking at the description on Docker Hub, we can see a number of Environment Variables, we will set these 4:

- MYSQL_ROOT_PASSWORD
- MYSQL_DATABASE
- MYSQL_USER
- MYSQL_PASSWORD

To do this in the deployment.yaml, we need to [add the environment variables](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/#using-environment-variables-inside-of-your-config) to an array as part of the container object

## Adding volumes

### 1. ConfigMap

We might want to use a standard deployment to create multiple database pods that have different variables. Instead of manually updating the deployment each time we want to make a change. Instead, we will [create a ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) that will contain the MYSQL_DATABASE and MYSQL_USER data.
To keep things simple, let's create the ConfigMap using [literal values](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-configmaps-from-literal-values). Run the following command:

`kubectl create configmap db-variables --from-literal=database=[database_name] --from-literal=db-user=[username]`

To use the two values we just set in the ConfigMap, we will modify the two Environment Variables and replace the clear text we wrote with a reference to the configmap data
We will replace the `value` field with a `valueFrom` field. This should look something like this:

`valueFrom:  
   configMapKeyRef:  
     name: api-variables  
     key: database`

You can learn more about this field using `kubectl explain` or using the [API reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.13/#container-v1-core)

### 2. Secrets
