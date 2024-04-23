FROM amazon/aws-cli:2.15.40

RUN yum update && yum install -y jq

WORKDIR /scripts

COPY . .

RUN chmod +x /scripts/docker-entrypoint.sh

ENTRYPOINT ["/scripts/docker-entrypoint.sh"]
