FROM alpine
ADD run.sh /
RUN chmod +x /run.sh
ENV SWAPPINESS 10
ENV SWAP_SIZE_IN_GB **None**
VOLUME /user
CMD ["/run.sh"]
