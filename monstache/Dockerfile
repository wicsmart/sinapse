FROM partlab/ubuntu-golang
ADD  build /build
RUN echo "export PATH=\"/build/linux-amd64:$PATH\"" >> ~/.bashrc
CMD source ~/.bashrc
CMD ["tail", "-f", "/dev/null"]
