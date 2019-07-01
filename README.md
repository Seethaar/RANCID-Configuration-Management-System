# RANCID-Configuration-Management-System
A smart solution for network configuration backup

The purpose of this project is deploy a source-controlled configuration management system across multiple vendors/platforms, primarily Cisco, Huawei and Palo Alto.

RANCID is the acronym for Really Awesome New Cisco confIg Differ. This is a Configuration Management solution written in Expect Language by Shrubbery Networks Inc. http://www.shrubbery.net/rancid/

In my implementation of a Configuration Management Solution for a personal project, I used Apache WebSVN for source control for the following reasons.
- User-friendly Web UI
- Centralised Source Control
- RSS feeds for updates

#### Implementation Challenges #1:
- Apart from Cisco, there are not many vendors that could be supported by Rancid. So this system could not be built as vendor agnostic.
- per-vendor configuration collection mechanism

#### Work Around #1:
- Rancid Inventory could be populated with dummy parameters for non-supported vendors. This paves a way to just avail the Source-Controllablity feature for non-supported platforms, provided we build a configuration collection mechanism, that can store the configuration backups into the source controlled repository.

Example Inventory File with format '\<IP\>:\<Vendor\>:\<state\>':
```
10.0.0.1:cisco:up
10.0.0.2:huawei:up
10.0.0.3:paloalto:up
10.0.0.4:dummy:up
.
```

On 'rancid-run', for the vendors/platforms that are not listed on,
/etc/rancid/rancid.types.conf
/etc/rancid/rancid.types.base

RANCID simply ignores them. If could build a another configuration collection mechanism such as XML API, SSH, Adhoc Rancid Modules etc., and store that in the /var/rancid/<platform>/configs folder, prior to 'rancid-run', then the WebSVN commit will include both the rancid collected and ones collected through other channels are committed.

Channels that I employed:
- For Huawei - I used adhoc command using rancid module 'hulogin' - https://github.com/ssinyagin/rancid-ssi/blob/master/bin/hulogin.in
- For PaloAlto - Bash script to cURL the XML API and grab the config

#### Implementation Challenge #2:
- Integration of all the moving parts. My implementation of rancid involves running a lot of BASH scripts on a timed manner.

##### Chronological Order:
- Collection of IP addresses of the active managed network elements - Bash script
- Palo Alto Config collection script
- Huawei Config collection script
- Rancid-run (Includes Cisco config collection) and WebSVN commit
- Failure analysis and reporting
- Cleanup and Log rotation
- Monthly report generation

#### Work Around #2:
- Crontab



