TASK1:-

project_id=Your_Project_ID

gcloud compute networks create vpc-transit --project=$project_id --subnet-mode=custom --mtu=1460 --bgp-routing-mode=global

TASK 2:- 

gcloud compute networks create vpc-a --project=$project_id --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional

gcloud compute networks create vpc-b --project=$project_id --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional

gcloud compute networks subnets create vpc-a-sub1-use4 --project=$project_id --range=10.20.10.0/24 --stack-type=IPV4_ONLY --network=vpc-a --region=us-east4

gcloud compute networks subnets create vpc-b-sub1-usw2 --project=$project_id --range=10.20.10.0/24 --stack-type=IPV4_ONLY --network=vpc-b --region=us-west2



TASK 3:-

Step 1: Create cloud routers


gcloud compute routers create cr-vpc-transit-use4-1 \
    --region us-east4 \
    --network vpc-transit \
    --asn 65000

gcloud compute routers create cr-vpc-transit-usw2-1 \
    --region us-west2 \
    --network vpc-transit \
    --asn 65000


gcloud compute routers create cr-vpc-a-use4-1 \
    --region us-east4 \
    --network vpc-a \
    --asn 65001


gcloud compute routers create cr-vpc-b-usw2-1 \
    --region us-west2 \
    --network vpc-b \
    --asn 65002



Step 2: Create HA VPN gateways


gcloud compute vpn-gateways create vpc-transit-gw1-use4 \
   --network=vpc-transit \
   --region=us-east4 


gcloud compute vpn-gateways create vpc-transit-gw1-usw2 \
   --network=vpc-transit \
   --region=us-west2 


gcloud compute vpn-gateways create vpc-a-gw1-use4 \
   --network=vpc-a \
   --region=us-east4 

gcloud compute vpn-gateways create vpc-b-gw1-usw2 \
   --network=vpc-b \
   --region=us-west2 



TASK 4:-

gcloud services enable networkconnectivity.googleapis.com 

gcloud alpha network-connectivity hubs create transit-hub \
   --description=Transit_hub

gcloud alpha network-connectivity spokes create bo1 \
    --hub=transit-hub \
    --description=branch_office1 \
    --vpn-tunnel=transit-to-vpc-a-tu1,transit-to-vpc-a-tu2 \
    --region=us-east4


gcloud alpha network-connectivity spokes create bo2 \
    --hub=transit-hub \
    --description=branch_office2 \
    --vpn-tunnel=transit-to-vpc-b-tu1,transit-to-vpc-b-tu2 \
    --region=us-west2


TASK 5:- 


gcloud compute --project=$project_id firewall-rules create fw-a --direction=INGRESS --priority=1000 --network=vpc-a --action=ALLOW --rules=tcp:22,icmp --source-ranges=0.0.0.0/0


gcloud compute --project=$project_id firewall-rules create fw-b --direction=INGRESS --priority=1000 --network=vpc-b --action=ALLOW --rules=tcp:22,icmp --source-ranges=0.0.0.0/0



gcloud compute instances create vpc-a-vm-1 --project=$project_id --zone=us-east4-c --machine-type=n1-standard-1 --network-interface=network-tier=PREMIUM,subnet=vpc-a-sub1-use4 --metadata=enable-oslogin=true --maintenance-policy=MIGRATE  --provisioning-model=STANDARD  --create-disk=auto-delete=yes,boot=yes,device-name=vpc-a-vm-1,image=projects/debian-cloud/global/images/debian-10-buster-v20221206,mode=rw,size=10,type=projects/$project_id/zones/us-east4-c/diskTypes/pd-balanced --no-shielded-secure-boot --no-shielded-vtpm --no-shielded-integrity-monitoring --reservation-affinity=any


gcloud compute instances create vpc-b-vm-1 --project=$project_id --zone=us-west2-b --machine-type=n1-standard-1 --network-interface=network-tier=PREMIUM,subnet=vpc-b-sub1-usw2 --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD  --create-disk=auto-delete=yes,boot=yes,device-name=vpc-b-vm-1,image=projects/debian-cloud/global/images/debian-10-buster-v20221206,mode=rw,size=10,type=projects/$project_id/zones/us-west2-c/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any










