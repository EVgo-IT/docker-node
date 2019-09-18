FROM node:lts

# Install Dependencies
RUN apt-get -y -qq update
RUN apt-get install -y curl python-pip python-dev build-essential apt-transport-https

# Install AWS CLI
RUN pip install awscli --upgrade

# Install Kubernetes CLI
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get -y -qq update
RUN apt-get install -y kubectl

# Install eksctl
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
RUN mv /tmp/eksctl /usr/local/bin

# Insall AWS-IAM-Authenticator
RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator
RUN chmod +x ./aws-iam-authenticator
RUN mv ./aws-iam-authenticator /usr/local/bin

# Install Postgres
RUN apt-get install -y postgresql postgresql-client
USER postgres
RUN /etc/init.d/postgresql start && psql --command "ALTER USER postgres PASSWORD 'postgres';"
USER root
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.6/main/pg_hba.conf
VOLUME /var/lib/postgresql/data
