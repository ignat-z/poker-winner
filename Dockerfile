FROM ubuntu:latest
COPY . /solution
WORKDIR /solution
RUN ./prepare.sh
CMD ./run.sh < test-cases.txt
