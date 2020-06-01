ARG borgbackup_version="1.1.11"

# Download the binary
FROM "bitnami/minideb:buster" AS downloader
ARG borgbackup_version
RUN install_packages \
	"curl" \
	"ca-certificates"

RUN curl --silent --show-error --location \
	--output "/usr/bin/borg" \
	"https://github.com/borgbackup/borg/releases/download/${borgbackup_version}/borg-linux64"

RUN chmod "+x" "/usr/bin/borg"

# Create the actual container
FROM "bitnami/minideb:buster"
ARG borgbackup_version

# Add the labels for the image
LABEL name="borg-client"
LABEL summary="Docker Container for the BorgBackup to be used as backup client"
LABEL maintainer="Mira 'Mireiawen' Manninen"
LABEL version="${borgbackup_version}"

# Install SSH client for remote jobs
RUN install_packages \
		"openssh-client"

# Install the actual backup
COPY --from=downloader \
	"/usr/bin/borg" \
	"/usr/bin/borg"


# Set the entry point
ENTRYPOINT [ "/usr/bin/borg" ]
CMD [ "--help" ]
