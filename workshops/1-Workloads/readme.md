# Workloads

1. How to deploy your application using a Deployment
2. Configure the container using Environment Variables
3. Add volumes
4. [Explore StatefulSet](https://cloud.google.com/kubernetes-engine/docs/concepts/statefulset)
5. Jobs Vs Deployments

## Using a Deployment

Using the basic deployment template (deployment.yaml), fill in the blank fields to deploy a basic database. To keep things simple, let's use the image for mysql from Docker Hub: ["mysql:5.7"](https://hub.docker.com/_/mysql).  
Once the yaml is ready, save your changes and create the deployment using:

'kubectl apply -f deployment.yaml'  

Changes in future steps can be applied easily in one of 2 ways:
1. Edit the deployment.yaml file locally. Once changes are complete, run the above command again to update the k8s resource
2. Edit the deployment resource directly through k8s using `kubectl edit deploy [deployment_name]`. Note that this uses vi to edit the resource directly.  

You can also use the `kubeclt patch` command to change specific fields in the resource without having to open an editor.

####Note
Whenever the deployment is modified, the update strategy defined will come into play. The readiness Probe is configured to wait 30 seconds before it starts to ensure the update strategy does not roll out too quickly. This should allow you time to watch the rollout strategy in action. 

## Setting Variables for the container

The MySQL database requires a root password which we will set through an environment variable. We can also set other variables such as a non root user, the non root user password and set a starting database.
Looking at the description on Docker Hub, we can see a number of Environment Variables, we will set these 4:

- MYSQL_ROOT_PASSWORD
- MYSQL_DATABASE
- MYSQL_USER
- MYSQL_PASSWORD

To do this in the deployment.yaml, we need to [add the environment variables](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/#using-environment-variables-inside-of-your-config) to an array as part of the container object
The deployment currently has a variable defined that allows access without a password, let's go ahead and replace that.

<pre>
containers:
- env:
  - name:
    value:
</pre>

## Adding volumes

### 1. ConfigMap

We might want to use a standard deployment to create multiple database pods that have different variables. Instead of manually updating the deployment each time we want to make a change. Instead, we will [create a ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) that will contain the MYSQL_DATABASE and MYSQL_USER data.
To keep things simple, let's create the ConfigMap using [literal values](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-configmaps-from-literal-values). Run the following command:

'kubectl create configmap db-variables --from-literal=database=[database_name] --from-literal=db-user=[username]'

Take a look at the resource you just created using `kubectl describe cm db-variables`

To use the two values we just set in the ConfigMap, we will modify the two Environment Variables and replace the clear text we wrote with a reference to the configmap data
We will replace the `value` field with a `valueFrom` field. It should look something like this:

<pre>
...
valueFrom:  
  configMapKeyRef:  
    name: api-variables  
    key: database
</pre>

You can learn more about this field using `kubectl explain` or using the [API reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.13/#container-v1-core)

### 2. Secrets

Our container currently has the 2 passwords writen in plain text in the config file. This is obviously not a good practice as we'd rather keep these passwords secure. Using a configMap here wouldn't help much as the data will be stored in clear readable text. Instead, we'll use a secret.
There are a number of ways to [generate the secret](https://kubernetes.io/docs/concepts/configuration/secret/#creating-your-own-secrets), for now, we'll create it from the command line; follow the steps to manually create a secret uing kubect from the kubernetes.io page.

Once the secret has been created, you can view the secret using `kubectl describe secret [secret_name]. Note that instead of having the values in clear test, the secret just makes a reference to the source file. This will also be the case if you create the secret from a literal value, you should only see the number of bytes of the value rather than a clear text value.

Now, update the deployment env fields to use the secrets. This will be very similar to how we referenced configMaps. Use `kubectl explain` or view the k8s API reference docs to find the correct values to change.

### 3. Persistent Volumes

We used configMap and secrets to replace variables in the container. It is also possible to have entire files created from either a secret or a configMap. The important part to note is that whatever data we import from the configMap or the secret will be readOnly. 
