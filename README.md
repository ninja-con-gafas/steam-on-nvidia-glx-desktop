# Steam on Selkies NVIDIA GLX Desktop

This repository provides a container image that extends the [Selkies NVIDIA GLX Desktop](https://github.com/selkies-project) environment with full **Steam client integration**, while maintaining compatibility with modern NVIDIA drivers and accelerated OpenGL rendering pipelines.

The containerised desktop environment supports hardware-accelerated graphics, a fully interactive graphical user interface delivered through the browser via Selkies WebRTC technology, and persistence of all Steam runtime data and game libraries.

---

## Features

- **Selkies GLX Desktop Foundation**: Built on the Selkies GLX Desktop stack, which provides a complete remote desktop solution with WebRTC integration, NVIDIA OpenGL support, and session management orchestrated by `supervisord`.

- **Steam Client Support**: The image installs the official Steam distribution.

- **Persistent Storage Architecture**: Game data and Steam user configuration are externalised via bind mounts or named volumes, enabling persistence across container lifecycle operations (creation, restart, rebuild, or upgrade).

- **Hardware Acceleration**: Leverages NVIDIA Container Toolkit and Direct Rendering Infrastructure (DRI) devices to expose GPU acceleration into the containerised desktop session, ensuring efficient execution of graphics-intensive workloads.

- **Compatibility with Docker and Podman**: The container is runtime-agnostic and can be executed seamlessly using either Docker Engine or Podman with NVIDIA GPU hooks configured.

---

## Directory and Volume Mapping

To persist all Steam runtime files, game libraries, and user configuration, mount the following directories:

_Yet to be implemented_

> Note: The default container user is `ubuntu`.

---

## Deployment Instructions

### Host Preparation

1. Ensure that the **NVIDIA GPU drivers** are installed and compatible with the NVIDIA Container Toolkit.  
2. Confirm that either **Docker** or **Podman** is configured with GPU passthrough support.  
3. Create persistent storage directories or named volumes for Steam data.

---

### Deployment 

```bash
podman run -d \
   --name steam \
   --restart=no \
   --security-opt label=disable \
   --tmpfs /dev/shm:rw \
   --gpus 0 \
   -e TZ=Asia/Kolkata \
   -e SELKIES_TURN_PROTOCOL=udp \
   -e SELKIES_TURN_PORT=3478 \
   -e TURN_MIN_PORT=65534 \
   -e TURN_MAX_PORT=65535 \
   -e SELKIES_TURN_HOST=${SELKIES_TURN_HOST} \
   -e NVIDIA_DRIVER_CAPABILITIES=all \
   -e WEBRTC_ENCODER=nvh264enc \
   -e SIZEW=1920 \
   -e SIZEH=1080 \
   -e REFRESH=60 \
   -e DPI=96 \
   -e CDEPTH=24 \
   -e VIDEO_PORT=DFP \
   -e PASSWD=${PASSWD} \
   -e BASIC_AUTH_PASSWORD=${BASIC_AUTH_PASSWORD} \
   -p 8082:8080 \
   -p 3478:3478 \
   -p 3478:3478/udp \
   -p 49152-65535:49152-65535/udp \
   ninjacongafas/steam-on-nvidia-glx-desktop:24.04-20250819
```

### Environment Variables

| Variable                                     | Purpose                                                                                                                                                                            |
| -------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `TZ=Asia/Kolkata`                            | Sets the container timezone to **Asia/Kolkata**. Ensures logs, timestamps, and any time-dependent operations within the container use the correct timezone.                        |
| `SELKIES_TURN_PROTOCOL=udp`                  | Specifies the transport protocol for the **TURN server** used by Selkies WebRTC. In this case, **UDP** is preferred for low-latency video streaming.                               |
| `SELKIES_TURN_PORT=3478`                     | Port number on which the TURN server listens for incoming WebRTC traffic. Standard TURN port is 3478.                                                                              |
| `TURN_MIN_PORT=65534`                        | Minimum port in the ephemeral range for TURN relay connections. Defines the lower bound of allowed UDP ports for media traffic.                                                    |
| `TURN_MAX_PORT=65535`                        | Maximum port in the ephemeral range for TURN relay connections. Defines the upper bound of allowed UDP ports for media traffic.                                                    |
| `SELKIES_TURN_HOST=${SELKIES_TURN_HOST}`     | Hostname or IP address of the TURN server used by the Selkies desktop. Must be set in the host environment or `.env` file before running.                                          |
| `NVIDIA_DRIVER_CAPABILITIES=all`             | Grants the container access to **all NVIDIA driver features**, including compute, graphics, video encoding/decoding, and display. Required for Steam and GLX desktop acceleration. |
| `WEBRTC_ENCODER=nvh264enc`                   | Selects the **hardware-accelerated H.264 video encoder** provided by NVIDIA for WebRTC streaming. Ensures efficient real-time video encoding.                                      |
| `SIZEW=1920`                                 | Sets the **width** of the virtual desktop in pixels.                                                                                                                               |
| `SIZEH=1080`                                 | Sets the **height** of the virtual desktop in pixels.                                                                                                                              |
| `REFRESH=60`                                 | Target **refresh rate** of the virtual desktop in Hertz.                                                                                                                           |
| `DPI=96`                                     | Sets the **dots-per-inch** for the virtual desktop display, affecting scaling of GUI elements.                                                                                     |
| `CDEPTH=24`                                  | Colour depth (in bits per pixel) of the virtual desktop. `24` corresponds to **true colour** (8 bits per channel).                                                                 |
| `VIDEO_PORT=DFP`                             | Specifies the default display output for the virtual desktop session. Typically `DFP` corresponds to the primary digital flat panel output.                                        |
| `PASSWD=${PASSWD}`                           | Optional password for user authentication in the Selkies desktop session. Must be provided in the host environment or `.env` file.                                                 |
| `BASIC_AUTH_PASSWORD=${BASIC_AUTH_PASSWORD}` | Optional password for HTTP basic authentication if the Selkies web interface is protected. Must be provided in the host environment or `.env` file.                                |

> Note: The `${VAR}` syntax indicates that the variable is **read from the host environment** or an `.env` file. You must define these before running the container.
---

## Accessing the Environment

1. After deployment, access the Selkies desktop environment via a web browser at `http://<host-ip>:8080`.
2. Within the graphical desktop, launch the **Steam client** from the application menu or terminal (`/usr/games/steam`).
3. Authenticate with your Steam account.
4. Download and manage games as on a conventional desktop system.
5. All data will persist across container restarts via the mounted volumes.

---

## Licensing

- The project, including all modifications and additions, is licensed under the
  **GNU Affero General Public License (AGPL-3.0)**.  
- The Selkies project components are licensed under the **Mozilla Public License 2.0 (MPL-2.0)**.  
- The base Linux distribution adheres to its upstream licensing terms.  
- The Steam client is distributed under proprietary licensing by Valve Corporation.  

---