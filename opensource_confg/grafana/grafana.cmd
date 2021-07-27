docker run -d \
--name=grafana -p 3000:3000 \
-v ./datasource.yml:/etc/prometheus/datasource.yml \
grafana/grafana

#in AWS
#docker run -d \
#-p 3000:3000 \
#--name=grafana \
#-e "GF_AWS_PROFILES=default" \
#-e "GF_AWS_default_ACCESS_KEY_ID=YOUR_ACCESS_KEY" \
#-e "GF_AWS_default_SECRET_ACCESS_KEY=YOUR_SECRET_KEY" \
#-e "GF_AWS_default_REGION=us-east-1" \
#grafana/grafana
