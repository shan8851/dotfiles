#!/usr/bin/env bash
# Build the win11-poker VM (Windows 11 under KVM/libvirt) with an unattended install.
# Needs: the packages and libvirt group from vm/README.md, plus win11.iso and virtio-win.iso in $VM_DIR/iso.
# Setup stops once at Microsoft's licence screen for you to accept; everything else runs itself.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
VM_DIR=${VM_DIR:-$HOME/vms}
NAME=win11-poker
ISO=$VM_DIR/iso
export LIBVIRT_DEFAULT_URI=qemu:///system

for f in win11.iso virtio-win.iso; do [[ -f $ISO/$f ]] || { echo "missing $ISO/$f (see vm/README.md)"; exit 1; }; done
virsh dominfo "$NAME" &>/dev/null && { echo "$NAME already exists"; exit 1; }

# Windows Setup picks up autounattend.xml from the root of any attached disc
genisoimage -quiet -J -r -V UNATTEND -o "$ISO/unattend.iso" "$HERE/autounattend.xml"

virsh net-info default 2>/dev/null | grep -q 'Active:.*yes' || { virsh net-start default; virsh net-autostart default; }

# SATA disk + Intel NIC so Setup needs no extra drivers; guest tools install at first login.
virt-install \
  --name "$NAME" --osinfo win11 \
  --memory 8192 --vcpus 4 --cpu host-passthrough \
  --machine q35 --features smm.state=on \
  --boot loader=/usr/share/OVMF/OVMF_CODE_4M.ms.fd,loader.readonly=yes,loader.type=pflash,loader.secure=yes,nvram.template=/usr/share/OVMF/OVMF_VARS_4M.ms.fd \
  --tpm backend.type=emulator,backend.version=2.0,model=tpm-crb \
  --disk path="$VM_DIR/$NAME.qcow2",size=80,format=qcow2,bus=sata,discard=unmap \
  --cdrom "$ISO/win11.iso" \
  --disk "$ISO/virtio-win.iso",device=cdrom,bus=sata \
  --disk "$ISO/unattend.iso",device=cdrom,bus=sata \
  --network network=default,model=e1000e \
  --graphics spice --video qxl --channel spicevmc --sound ich9 \
  --clock offset=localtime \
  --noautoconsole

# The installer shows "press any key to boot from CD" for a few seconds; press it for you.
for _ in $(seq 20); do virsh send-key "$NAME" KEY_ENTER &>/dev/null || true; sleep 1; done

echo "Started. Open it with: virt-viewer --wait --reconnect $NAME"
echo "virt-install stops the VM at the first reboot: run 'virsh start $NAME' once if the window goes blank."
