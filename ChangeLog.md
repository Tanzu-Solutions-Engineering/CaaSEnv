# Log of Operational Changes

Whenever something new is completed on the CaaS environment please record here with timestamp.
Reference Markdown tutorial here for quick reference on formatting:  
https://guides.github.com/features/mastering-markdown/#GitHub-flavored-markdown

Format should be:

**Date** (bolded using double asterik) 
*Operation* (italicized using single asterik) 
- Notes (plain text bullet point using "-")

## Logs

**01-28-20**   *Upgrade infrastructure with VxRail Manager*
 - upgrade has completed without issue - VxRail, ESXi and vCenter have all been upgraded.
 - may need to rebalance vSAN now

**01-27-20**   *Upgrade infrastructure with VxRail Manager*
  - after failed attempt to upgrade with VMware Upgrade Manager, reverted to using VxRail Manager to upgrade
  - navigate in vSphere: VxRail-SAN > Configure tab > VxRail (scroll down) > System > Update (on page)
  - had to download files from Dell. Unfortunately, Dell would only give download to Brian, but not Steve or Hemath
  - found out that legacy password with vxRail (vxrailcaas,  7x@W------) did not work so used the VM Root password instead
  - update process kicked off at ~10:00 PST

**01-23-20**   *Changed NSX-T back to ftp to current Ops Manager*
 - a few weeks ago Ops Manager was falling because the disk was full.  Louis from PEZ deployed a new OpsMan
 - we didn't realize at the time, but NSX-T backups we directed to OpsMan
 - Brian changed NSX-T backups to point to our new OpsMan
 - will need to come up with system to archive or delete old backups

**01-22-20**
  *Updated stem cells for Harbor*
  - downloaded and applied stem cells to get Harbor up to current stem cell for the version
  - will still need to update Harbor itself and of course more stem cells

**01-21-20**
  *re-generated certs on OpsMan*
- Users were having trouble logging into OpsMan on Chrome browser, and there was a warning that certs were expiring
- worked through the docs to re-generate leaf certs (main OpsMan cert was fine)
- documented the process in this archive

**01-21-20:**   *ran update to PKS 1.5*
- deleted clusters "workshop1" and "workshop2" . NOTE: this was a problem as the clusters would not respond.  
- We were forced to delete in bosh using '--force' flag, and then run 'pks delete-cluster' to clear from PKS datastore.
   
