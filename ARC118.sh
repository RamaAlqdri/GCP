export REGION=


gcloud pubsub topics create $DEVSHELL_PROJECT_ID-topic

gcloud  pubsub subscriptions create --topic $DEVSHELL_PROJECT_ID-topic $DEVSHELL_PROJECT_ID-topic-sub

gcloud run deploy pubsub-events \
  --image=gcr.io/cloudrun/hello \
  --platform=managed \
  --region=$REGION \
  --allow-unauthenticated


gcloud eventarc triggers create pubsub-events-trigger \
  --location=$REGION \
  --destination-run-service=pubsub-events \
  --destination-run-region=$REGION \
  --transport-topic=$DEVSHELL_PROJECT_ID-topic \
  --event-filters="type=google.cloud.pubsub.topic.v1.messagePublished"

gcloud pubsub topics publish $DEVSHELL_PROJECT_ID-topic \
  --message="Test message"




