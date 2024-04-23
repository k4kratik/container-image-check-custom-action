FROM amazon/aws-cli:2.15.40

WORKDIR /scripts

COPY . .

ENTRYPOINT ["/scripts/script.sh"]
