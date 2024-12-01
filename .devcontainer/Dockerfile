FROM ubuntu:24.04

ARG DIRENV_VERSION=2.32.3
ARG CHEFHAB_VERSION=19.0.58/20241127134641

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ARG CHEF_LICENSE=accept-silent
ARG HAB_LICENSE=accept
ARG CHEF_LICENSEKEY

# System base with common tooling
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install --no-install-recommends --yes \
        lsb-release vim sudo curl wget apt-utils dialog apt-transport-https ca-certificates unzip software-properties-common \
        yamllint python3-pip git less jq ssh patchutils \
    && apt-get autoremove --yes \
    && apt-get clean --yes \
    && rm -rf /var/lib/apt/lists/* \
    #
    && curl --location-trusted "https://github.com/direnv/direnv/releases/download/v${DIRENV_VERSION}/direnv.linux-amd64" --output /usr/local/bin/direnv --silent \
    && chmod +x /usr/local/bin/direnv

RUN curl --silent https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash \
    && hab cli completers --shell bash > /etc/bash_completion.d/hab \
    && hab pkg install chef/chef-infra-client/${CHEFHAB_VERSION} \
    && echo 'alias chef-client="hab pkg exec chef/chef-infra-client chef-client"' >> /etc/bash.bashrc \
    && mkdir /home/vscode/.chef \
    && echo -e "---\n:file_format_version: 4.0.0\n:licenses:\n- :license_key: $CHEF_LICENSEKEY\n  :license_type: :free\n  :update_time: '2024-12-01T00:00:00+00:00'\n:license_server_url: https://services.chef.io/licenseing\n" > /home/vscode/.chef/licenses.yaml

# User configuration
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && echo 'eval "$(direnv hook bash)"' >> /home/$USERNAME/.bashrc