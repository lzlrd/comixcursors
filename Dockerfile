FROM debian:latest

LABEL description="Xcursors build and distribution environment based on Debian Linux."

RUN apt-get update
RUN apt-get install --yes librsvg2-bin make x11-apps bc git python python-docutils rpm
