#!/bin/bash

# If the html directory is mounted, it means user has mounted some content in it.
# In that case, we must not over-write the index.html file.

WEB_ROOT=/usr/share/nginx/html
MOUNT_CHECK=$(mount | grep ${WEB_ROOT})




# If the env variables HTTP_PORT and HTTPS_PORT are defined, then
#   modify/Replace default listening ports 80 and 443 to whatever the user wants.
# If these variables are not defined, then the default ports 80 and 443 are used.


# Execute the command specified as CMD in Dockerfile:
exec "$@"
