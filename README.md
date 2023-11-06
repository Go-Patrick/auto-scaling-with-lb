# auto-scaling-with-lb
## Overview
This repository is an example of using Terraform to set up Auto-scaling group with Load balancer
## Lauch template
Each instance of auto-scaling group will launch with Amazon Linux 2023.

The userdata.tpl represent the setting up phase. In this case i use it to install Docker and also docker-compose for running my app.
## Autoscaling
The management of auto-scaling and its rules are handled by cloudwatch metrics.
## Load balancer
### Target group
First I create the target group then connect it to auto-scaling group. this target group help load balancer know which traffic to redirect
### Load balancer
Now associate the Terget group with Load balancer, listen on port 80 then forward requests.
