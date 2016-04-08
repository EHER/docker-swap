FROM alpine
ADD run.sh /
ENV SWAPPINESS 10
ENV SWAP_SIZE_IN_GB **None**
CMD ["/run.sh"]
