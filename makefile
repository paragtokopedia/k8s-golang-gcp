#docker exec -i -t 110bdf16efb5 /bin/bash

DEVSHELL_PROJECT_ID=conecktor
SERVER_NAME=test

deploy: cbuild kdeploy knodeport kapply
build:
	docker build -t my-web-server .
run:
	docker run -d -p 8080:80 my-web-server
cbuild:
	gcloud builds submit -t gcr.io/$(DEVSHELL_PROJECT_ID)/$(SERVER_NAME) 
cpush:
	docker tag my-web-server gcr.io/$(DEVSHELL_PROJECT_ID)/$(SERVER_NAME)
	docker images
	gcloud docker -- push gcr.io/$(DEVSHELL_PROJECT_ID)/$(SERVER_NAME)
kdeploy:
	kubectl run $(SERVER_NAME)-gke --image=gcr.io/$(DEVSHELL_PROJECT_ID)/$(SERVER_NAME) --port=8080
kloadbalancer:
	kubectl expose deployment  $(SERVER_NAME)-gke --type=LoadBalancer --port=80 --target-port=8080
kscale:
	kubectl scale deployment $(SERVER_NAME)-gke --replicas=3
knodeport:
	kubectl expose deployment $(SERVER_NAME)-gke --target-port=8080 --type=NodePort     
kapply:
	kubectl apply -f basic-ingress.yaml	           
cleanup: 
	kubectl delete ingress basic-ingress1
	kubectl delete service $(SERVER_NAME)-gke
	kubectl delete deployment $(SERVER_NAME)-gke