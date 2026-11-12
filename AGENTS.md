# Vault cookbook migration guidance

* Confirmed scope: full custom resource migration, published as version 7.0.0 instead of the previous patch release.
* Root recipes and attributes remain absent. Preserve all existing resource names and configuration formats.
* Keep supported modern platforms aligned across metadata, all Kitchen files and CI. Obsolete Amazon Linux 2, CentOS 7/Stream 8, Debian 10/11, Ubuntu 18.04/20.04 and Leap 15 are replaced with their current successors.
* Package installation uses HashiCorp repositories on Debian/Ubuntu, RHEL-family and Amazon Linux. Fedora 45 has no matching vendor package repository; openSUSE has no supported repository method. Exercise the official binary/ARK method on these platforms rather than silently substituting another distribution repository.
* Official package and repository information: <https://developer.hashicorp.com/vault/install> and <https://www.hashicorp.com/official-packaging-guide>.
* Public signing key rotated in September 2026. Current fingerprint D55C0D1AC78A8D8126CB631CFC9CA96ACA026560 is verified against <https://www.hashicorp.com/trust/security>. Do not disable signature checks for old archive metadata signed by the previous key.
* Binary archives from releases.hashicorp.com support Linux amd64 and arm64; the helper maps aarch64 to arm64. Integration evidence on this Mac is arm64; GitHub CI verifies amd64.
* Preserve per-instance service names on deletion and leave shared service users/groups intact.
* Every integration profile has controls/ and an inspec.yml without platform filters. Default exercises binary installation, HCL configuration and the running service.
* Amazon Linux uses the vendor's `AmazonLinux/latest` repository path, verified against <https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo>; do not substitute OS releasever.
* APT repository architecture follows the kernel architecture (aarch64 maps to arm64). Repository distribution uses Ohai lsb codename and does not spawn lsb_release during convergence.
* ARK removal deletes binary/home links, its selected version directory and archive. Shared service users/groups and the shared /opt/vault parent remain available to other instances.
* Binary installs require capability tools: libcap2-bin on Debian, libcap-progs on SUSE and libcap on RPM families. Fresh Leap 16 images do not include setcap.
