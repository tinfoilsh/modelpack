FROM ollama/ollama

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install jq erofs-utils cryptsetup -y

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
