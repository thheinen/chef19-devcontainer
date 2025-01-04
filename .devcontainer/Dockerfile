FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# See https://bldr.habitat.sh/#/pkgs/chef/chef-infra-client/latest
ARG CHEFHAB_VERSION=19.0.59/20241203230658
ARG CHEF_LICENSEKEY

ENV USERNAME=vscode
ENV USER_UID=1000
ENV USER_GID=$USER_UID
ENV CHEF_LICENSE=accept-silent
ENV HAB_LICENSE=accept
ENV HAB_BLDR_CHANNEL=LTS-2024

# System base with common tooling
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install --no-install-recommends --yes \
        lsb-release vim sudo curl wget apt-utils dialog apt-transport-https ca-certificates unzip software-properties-common \
        yamllint python3-pip git less jq ssh patchutils \
    && apt-get autoremove --yes \
    && apt-get clean --yes \
    && rm -rf /var/lib/apt/lists/*

# Get Chef
RUN curl --silent https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | bash \
    && hab cli completers --shell bash > /etc/bash_completion.d/hab \
    && hab pkg install chef/chef-infra-client/${CHEFHAB_VERSION} \
    && echo -n "#!/bin/bash\nhab pkg exec chef/chef-infra-client chef-client $@\n" >> /usr/local/bin/chef-client \
    && chmod +x /usr/local/bin/chef-client \
    && mkdir /home/vscode/.chef \
    && echo -e "---\n:file_format_version: 4.0.0\n:licenses:\n- :license_key: $CHEF_LICENSEKEY\n  :license_type: :free\n  :update_time: '2024-12-01T00:00:00+00:00'\n:license_server_url: https://services.chef.io/licensing\n" > /home/vscode/.chef/licenses.yaml \
    && chown vscode:vscode -R /home/vscode/.chef/

# Make this usable as dev environment
RUN /hab/pkgs/core/ruby3_1/3.1.6/*/bin/gem install test-kitchen kitchen-transport-train kitchen-ec2 toml-rb \
    && echo 'export PATH="$PATH:$(find /hab/pkgs/core/ruby3_1/3.1.6/*/bin/ -type d)"' >> /etc/bash.bashrc
