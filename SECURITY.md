# Security Policy

## Supported Use

This repository is published primarily as a learning resource and a reusable starting point.

The `dev` mode is the maintained path for local use.
The `prod` mode is kept as an educational example and should be reviewed and adapted before any real-world deployment.

## Reporting a Vulnerability

Please do not open a public issue for suspected secrets, credentials, or exploitable production misconfiguration.

Instead, report it privately to the repository owner through GitHub private vulnerability reporting if enabled, or by direct contact through the maintainer profile.

When reporting, include:

- the affected file or command
- the risk you identified
- the steps to reproduce or validate it
- any suggested mitigation

## Scope Notes

The following are out of scope unless they expose a concrete secret or security flaw in this repository:

- placeholder example values
- the preserved `prod` example configuration by itself
- local mkcert-generated files that are already ignored by Git
