# Windows VM (win11-poker)

A Windows 11 VM under KVM/libvirt, for Windows-only apps (the Unibet poker client). Windows 11 Pro, unactivated: you get a watermark and can't change the wallpaper, nothing else.

**Spec:** 4 vCPU, 8 GB RAM, 80 GB SATA disk, UEFI with Secure Boot, TPM 2.0, SPICE display. The guest tools give auto-resize, a shared clipboard and sound.

**Day to day:** `poker-up` / `poker-down` (in `zsh/.zshrc`), or "Poker VM" in the app menu. Closing the viewer leaves the VM running.

The VM's disk, ISOs and backups live in `~/vms`, outside this repo.

## Fresh install

```bash
sudo apt install -y virt-manager libvirt-daemon-system swtpm swtpm-tools virt-viewer ovmf genisoimage
sudo usermod -aG libvirt "$USER"
# Then REBOOT. Logging out isn't enough on Plasma 6: the systemd user session survives it and keeps the old groups.
```

Downloads go in `~/vms/iso`:
- **`win11.iso`:** microsoft.com/software-download/windows11, "Windows 11 (multi-edition ISO for x64 devices)". Check `sha256sum` against the hash table on that page.
- **`virtio-win.iso`:** `curl -L -o ~/vms/iso/virtio-win.iso https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso`

Then run `vm/create.sh`, open the viewer and accept the licence. It takes about 20 minutes and a few reboots. If the window goes blank at the first reboot, run `virsh start win11-poker`.

**What the answer file (`autounattend.xml`) does:** UK keyboard, region and time zone. A local account `shan` with no password and no Microsoft-account prompt. Privacy options at the minimum, virtio guest tools at first login. It deliberately doesn't accept the Microsoft licence for you.

After it's on the desktop, eject the install discs:

```bash
for d in sdb sdc sdd; do virsh change-media win11-poker $d --eject --live --config; done
```

## Windows settings for poker

In Terminal (Admin) inside Windows:

```powershell
powercfg /change standby-timeout-ac 0; powercfg /change monitor-timeout-ac 0; Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' ActiveHoursStart 8; Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' ActiveHoursEnd 2
```

This stops Windows sleeping or blanking mid-session, and stops it restarting for updates between 08:00 and 02:00. Turn on Do Not Disturb from the clock before playing. For a high-res screen, set Display → Scale (100% at 1440p, 150% at 4K).

## Backup and restore

The disk is root-owned while libvirt manages it, so copy it through a libvirt storage pool (no sudo). Shut the VM down first.

```bash
virsh pool-define-as vms dir --target ~/vms && virsh pool-start vms && virsh pool-autostart vms   # once
virsh vol-download --pool vms win11-poker.qcow2 ~/vms/backup/win11-poker-$(date +%F).qcow2 --sparse
virsh vol-upload   --pool vms win11-poker.qcow2 ~/vms/backup/<backup>.qcow2                     # restore
```

The virtual TPM isn't backed up. That's fine unless BitLocker or Windows Hello gets turned on, so don't.

## Gotchas
- PokerStars may refuse to run in a VM. That's untested here, and the VM shouldn't be disguised to get round it.
- Ctrl+Alt releases the mouse and keyboard if they get stuck in the viewer.
