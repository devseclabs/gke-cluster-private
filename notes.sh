ssh cluster-bastion
# run in the bastion
sudo apt-get install tinyproxy
sudo echo "Allow localhost" > /etc/tinyproxy/tinyproxy.conf
sudo service tinyproxy restart

#run in your pc
CLUSTER_NAME="cluster-name"
CLUSTER_ZONE="cluster-zone"
CLUSTER_PROJECT_NAME="project-name"

gcloud container clusters get-credentials $CLUSTER_NAME \
  --zone $CLUSTER_ZONE \
  --project $CLUSTER_PROJECT_NAME

BASTION_INSTANCE_NAME="bastion-name"

gcloud compute ssh $BASTION_INSTANCE_NAME \
  --project $CLUSTER_PROJECT_NAME \
  --zone $CLUSTER_ZONE \
  --  -L 8888:localhost:8888 -N -q -f