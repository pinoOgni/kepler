#!/bin/bash

sed -i '/volumeMounts:/a\        - mountPath: \/usr\/src\n\          name: usr-src' ../_output/generated-manifest/deployment.yaml
sed -i '/volumes:/a\      - hostPath:\n\          path: \/usr\/src\n\          type: Directory\n\        name: usr-src' ../_output/generated-manifest/deployment.yaml


